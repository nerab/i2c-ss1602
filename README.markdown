# SainSmart 1602 I2C driver

This is a Ruby driver for the SainSmart 1602 LCD display with I2C adapter. The code was partially ported from [raspi-gpio](https://github.com/paulbarber/raspi-gpio/blob/master/lcd_display.py).

## Installation

Add this line to your application's Gemfile:

```
gem 'i2c-ss1602'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install i2c-ss1602
```

## Usage

```ruby
require 'i2c/drivers/ss1602'
display = I2C::Drivers::SS1602::Display.new('/dev/i2c-1', 0x27)
display.clear
display.text('Hello', 0)
display.text('World', 1)
```
