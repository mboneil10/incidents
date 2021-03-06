# frozen_string_literal: true

require 'spec_helper'

describe 'special supervisor report fields' do
  let(:supervisor) { create :user, :supervisor }
  before(:each) { when_current_user_is supervisor }
  let(:supervisor_incident_report) { create :incident_report, user: supervisor }
  let(:incident) { create :incident, supervisor_incident_report: supervisor_incident_report }
  it 'allows filling in the number of saved pictures' do
    incident.supervisor_report.update! pictures_saved: false
    visit edit_supervisor_report_url(incident.supervisor_report)
    expect(page).not_to have_text 'Number of pictures saved'
    check 'Were pictures taken?'
    wait_for_animation!
    expect(page).to have_text 'Number of pictures saved'
  end
  it 'does not require filling in the number of saved pictures' do
    visit edit_supervisor_report_url(incident.supervisor_report)
    check 'Were pictures taken?'
    wait_for_animation!
    fill_in 'Number of pictures saved', with: ''
    click_button 'Save supervisor report'
    wait_for_ajax!
    expect(page).to have_selector 'p.notice',
      text: 'Incident report was successfully saved.'
  end
  it 'shows the number of saved pictures for reports where it applies' do
    incident.supervisor_report.update! pictures_saved: true
    visit edit_supervisor_report_url(incident.supervisor_report)
    expect(page).to have_text 'Number of pictures saved'
  end

  it 'allows filling in witness information' do
    incident.supervisor_report.witnesses.delete_all
    visit edit_supervisor_report_url(incident.supervisor_report)
    expect(page).not_to have_text 'Witness Information'
    check 'Were there witnesses?'
    wait_for_animation!
    expect(page).to have_text 'Witness Information'
  end
  it 'requires filling in the witness information' do
    incident.supervisor_report.witnesses.delete_all
    visit edit_supervisor_report_url(incident.supervisor_report)
    check 'Were there witnesses?'
    click_button 'Save supervisor report'
    wait_for_ajax!
    expect(page).to have_text "Witnesses name can't be blank"
  end
  it 'shows witness information for reports where it applies' do
    incident.supervisor_report.witnesses.delete_all
    create :witness, supervisor_report: incident.supervisor_report
    visit edit_supervisor_report_url(incident.supervisor_report)
    expect(page).to have_text 'Witness Information'
    fill_in 'Name', with: 'Cornelius Fudge'
    click_button 'Save supervisor report'
    wait_for_ajax!
    expect(page).to have_selector 'p.notice',
      text: 'Incident report was successfully saved.'
    expect(page).to have_text 'Cornelius Fudge'
  end

  it 'allows filling in fields related to a test not being completed' do
    incident.supervisor_report.update! completed_drug_or_alcohol_test: true
    visit edit_supervisor_report_url(incident.supervisor_report)
    expect(page).not_to have_text 'Please document why a test was not conducted.'
    uncheck 'Completed drug or alcohol test?'
    expect(page).to have_text 'Please document why a test was not conducted.'
  end
  it 'requires selecting a reason why a test was not conducted' do
    visit edit_supervisor_report_url(incident.supervisor_report)
    uncheck 'Completed drug or alcohol test?'
    uncheck :supervisor_report_fta_threshold_not_met
    uncheck :supervisor_report_driver_discounted
    click_button 'Save supervisor report'
    wait_for_ajax!
    expect(page).to have_text 'You must provide a reason why no test was conducted.'
  end

  it 'allows filling in a reason why the FTA threshold was not met' do
    incident.supervisor_report.update! completed_drug_or_alcohol_test: false,
      fta_threshold_not_met: false, driver_discounted: true, reason_driver_discounted: 'Placeholder'
    visit edit_supervisor_report_url(incident.supervisor_report)
    expect(page).not_to have_text 'Please explain how the FTA threshold is not met.'
    check 'Accident does not meet FTA post-accident testing criteria. Therefore, no drug or alcohol testing is permitted under FTA.'
    wait_for_animation!
    expect(page).to have_text 'Please explain how the FTA threshold is not met.'
  end
  it 'requires explaining how the FTA threshold was not met' do
    incident.supervisor_report.update! completed_drug_or_alcohol_test: false,
      fta_threshold_not_met: false, driver_discounted: true, reason_driver_discounted: 'Placeholder'
    visit edit_supervisor_report_url(incident.supervisor_report)
    check 'Accident does not meet FTA post-accident testing criteria. Therefore, no drug or alcohol testing is permitted under FTA.'
    click_button 'Save supervisor report'
    wait_for_ajax!
    expect(page).to have_text 'This supervisor report has 1 missing value and so cannot be marked as completed.'
  end
  it 'shows FTA threshold information when it applies' do
    incident.supervisor_report.update! completed_drug_or_alcohol_test: false,
      fta_threshold_not_met: true, driver_discounted: false, reason_threshold_not_met: 'Placeholder'
    visit edit_supervisor_report_url(incident.supervisor_report)
    expect(page).to have_text 'Please explain how the FTA threshold is not met.'
  end

  it 'allows filling in a reason why a driver can be discounted' do
    incident.supervisor_report.update! completed_drug_or_alcohol_test: false,
      driver_discounted: false, fta_threshold_not_met: true, reason_threshold_not_met: 'Placeholder'
    visit edit_supervisor_report_url(incident.supervisor_report)
    expect(page).not_to have_text 'Please explain why the driver can be discounted.'
    check 'I can completely discount the operator, a safety-sensitive employee, as a contributing factor to the incident.'
    wait_for_animation!
    expect(page).to have_text 'Please explain why the driver can be discounted.'
  end
  it 'requires explaining why the driver can be discounted' do
    incident.supervisor_report.update! completed_drug_or_alcohol_test: false,
      driver_discounted: false, fta_threshold_not_met: true, reason_threshold_not_met: 'Placeholder',
      reason_driver_discounted: nil
    visit edit_supervisor_report_url(incident.supervisor_report)
    check 'I can completely discount the operator, a safety-sensitive employee, as a contributing factor to the incident.'
    click_button 'Save supervisor report'
    wait_for_ajax!
    expect(page).to have_text 'This supervisor report has 1 missing value and so cannot be marked as completed.'
  end
  it 'shows driver discount information when it applies' do
    incident.supervisor_report.update! completed_drug_or_alcohol_test: false,
      driver_discounted: true, fta_threshold_not_met: false, reason_driver_discounted: 'Placeholder'
    visit edit_supervisor_report_url(incident.supervisor_report)
    expect(page).to have_text 'Please explain why the driver can be discounted.'
  end
end
