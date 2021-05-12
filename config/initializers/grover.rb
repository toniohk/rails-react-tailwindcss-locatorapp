# config/initializers/grover.rb
Grover.configure do |config|
  config.options = {
    format: 'A4',
    margin: {
      top: '10px',
      bottom: '10px',
      left: '10px',
      right: '10px'
    },
    timeout: 0, # Timeout in ms. A value of `0` means 'no timeout'
    cache: false
  }
  
end