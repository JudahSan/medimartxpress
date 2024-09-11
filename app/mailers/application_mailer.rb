# frozen_string_literal: true

# ApplicationMailer is the base class for all mailers in the application.
# It inherits from ActionMailer::Base and sets default options for mailers,
# such as the default "from" email address and layout to use for email templates.
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
end
