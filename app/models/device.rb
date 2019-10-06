# frozen_string_literal: true

class Device < ApplicationRecord
  validates :name, :mac, :cel, presence: true
  after_create :create_dashboard
  # after_update :update_dashboard

  def send_alert
    Twilio::REST::Client.new.messages.create({
      from: TWILIO['twilio_phone_number'],
      to: cel,
      body: "ALERTA #{name.upcase}: Alguém no carro!"
    })
  end

  def create_dashboard
    Grafana.create(mac)
  end

  def update_dashboard
    Grafana.update(mac)
  end
end
