require 'i2c'

module I2C
  module Drivers
    module SS1602
      #
      # Driver class for the SainSmart 1602 I2C LCD Display.
      #
      # see https://github.com/andec/i2c
      #
      # Parts copied from https://github.com/paulbarber/raspi-gpio/blob/master/lcd_display.py
      #
      class Display
        # commands
        COMMAND_CLEARDISPLAY   = 0x01
        COMMAND_RETURNHOME     = 0x02
        COMMAND_ENTRYMODESET   = 0x04
        COMMAND_DISPLAYCONTROL = 0x08
        COMMAND_CURSORSHIFT    = 0x10
        COMMAND_FUNCTIONSET    = 0x20
        COMMAND_SETCGRAMADDR   = 0x40
        COMMAND_SETDDRAMADDR   = 0x80

        # flags for display entry mode
        FLAG_ENTRYRIGHT          = 0x00
        FLAG_ENTRYLEFT           = 0x02
        FLAG_ENTRYSHIFTINCREMENT = 0x01
        FLAG_ENTRYSHIFTDECREMENT = 0x00

        # flags for display on/off control
        FLAG_DISPLAYON  = 0x04
        FLAG_DISPLAYOFF = 0x00
        FLAG_CURSORON   = 0x02
        FLAG_CURSOROFF  = 0x00
        FLAG_BLINKON    = 0x01
        FLAG_BLINKOFF   = 0x00

        # flags for display/cursor shift
        FLAG_DISPLAYMOVE = 0x08
        FLAG_CURSORMOVE  = 0x00
        FLAG_MOVERIGHT   = 0x04
        FLAG_MOVELEFT    = 0x00

        # flags for function set
        FLAG_8BITMODE = 0x10
        FLAG_4BITMODE = 0x00
        FLAG_2LINE    = 0x08
        FLAG_1LINE    = 0x00
        FLAG_5x10DOTS = 0x04
        FLAG_5x8DOTS  = 0x00

        # flags for backlight control
        FLAG_BACKLIGHT   = 0x08
        FLAG_NOBACKLIGHT = 0x00

        BIT_EN = 0b00000100 # Enable bit
        BIT_RW = 0b00000010 # Read/Write bit
        BIT_RS = 0b00000001 # Register select bit

        class BusDevice
          def initialize(bus, address)
            @bus, @address = bus, address
          end        
          
          def write(data)
            @bus.write(@address, data)
          end
        end

        def initialize(bus_or_bus_name, device_address)
          if bus_or_bus_name.respond_to?(:write) 
            @device = BusDevice.new(bus_or_bus_name, device_address)
          else
            @device = BusDevice.new(I2C.create(bus_or_bus_name), device_address)
          end
          
          init_sequence
        end

        def clear
          write(COMMAND_CLEARDISPLAY)
          write(COMMAND_RETURNHOME)
        end

        def text(string, line)
          if line == 0
            write(0x80)
          elsif line == 1
            write(0xC0)
          else
            raise "Only line 0 or 1 are supported"
          end

          string.each_char do |c|
            write(c.ord, BIT_RS)
          end
        end

      private

        def init_sequence
          write(0x03)
          write(0x03)
          write(0x03)
          write(0x02)

          write(COMMAND_FUNCTIONSET | FLAG_2LINE | FLAG_5x8DOTS | FLAG_4BITMODE)
          write(COMMAND_DISPLAYCONTROL | FLAG_DISPLAYON)
          write(COMMAND_CLEARDISPLAY)
          write(COMMAND_ENTRYMODESET | FLAG_ENTRYLEFT)
          sleep(0.2)
        end

        #
        # Clocks EN to latch command
        #
        def strobe(data)
          @device.write(data | BIT_EN | FLAG_BACKLIGHT)
          sleep(0.0005)
          @device.write(((data & ~BIT_EN) | FLAG_BACKLIGHT))
          sleep(0.001)
        end

        def write_four_bits(data)
          @device.write(data | FLAG_BACKLIGHT)
          strobe(data)
        end

        #
        # Write a command to lcd
        #
        def write(cmd, mode = 0)
          write_four_bits(mode | (cmd & 0xF0))
          write_four_bits(mode | ((cmd << 4) & 0xF0))
        end
      end
    end
  end
end
