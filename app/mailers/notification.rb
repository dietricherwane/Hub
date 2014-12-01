class Notification < ActionMailer::Base
  default from: "PayMoney"

  def qualification_submission(user, bank, ecommerce)
    @user = user
    @bank = bank
    @ecommerce = ecommerce

    mail(to: "dietricherwane@yahoo.fr", subject: "Demande de qualification de Site Web")
  end

  def ecommerce_qualified(user, bank, ecommerce)
    @user = user
    @bank = bank
    @ecommerce = ecommerce

    mail(to: "dietricherwane@yahoo.fr", subject: "Validation de votre demande de qualification de Site Web")
  end
end
