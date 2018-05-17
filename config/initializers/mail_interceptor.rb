class SandboxEmailInterceptor
  def self.delivering_email(message)
    File.open("/tmp/debug-email", "a") { |f| f.write(message); f.write("\n\n\n>>>>> END <<<<<\n"); }
  end
end

ActionMailer::Base.register_interceptor(SandboxEmailInterceptor)
