Rails.application.config.middleware.use ExceptionNotification::Rack,
  email: {
    email_prefix: "[xaurius-api] err", # customize the subject line
    sender_address: "COPIBIT <#{ENV.fetch("SMTP_USERNAME", "err@xaurius.com")}>",
    exception_recipients: %w{nitzaalfinas@gmail.com},
    delivery_method: :smtp,
    smtp_settings: {
      address: ENV.fetch("NN_SMTP_DOMAIN", "localhost"),
      port: 1025,
      domain: ENV.fetch("NN_SMTP_DOMAIN", "localhost"),
      user_name: ENV.fetch("SMTP_USERNAME", "err@xaurius.com"),
      password: "12345678"
    }
  }
