# frozen_string_literal: true

FactoryBot.define do
  factory :incident do
    association :driver_incident_report,
                factory: %i[incident_report driver_report]
    association :supervisor_incident_report,
                factory: %i[incident_report supervisor_report]
    association :supervisor_report
    completed false

    trait :completed do
      completed true
      association :reason_code
      second_reason_code { Incident::SECOND_REASON_CODES.sample }
      root_cause_analysis { FFaker::BaconIpsum.paragraph }
    end

    trait :unclaimed do
      supervisor_incident_report nil
      supervisor_report nil
    end
  end
end
