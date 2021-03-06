alreadyExportedWarning = (count) ->
  words = if count == 1
    ['incident has', 'this incident']
  else ['incidents have', 'these incidents']
  """
  #{count} selected #{words[0]} already been exported to Hastus.
  Please confirm that you would like to re-export #{words[1]}.
  """

handleExporting = ->
  inSelectMode = $('table.incidents th.batch-hastus-export').is ':visible'
  if inSelectMode
    ids = $('.batch-hastus-export input:checked').map ->
      $(this).data 'id'
    .toArray()
    alreadyExported= $('.batch-hastus-export input:checked').filter ->
      $(this).data 'exported_to_hastus'
    .length
    if alreadyExported > 0
      unless confirm alreadyExportedWarning(alreadyExported)
        return false
     window.location.href = 'incidents/batch_hastus_export?' + $.param(ids: ids)
  else
    $('table.incidents .batch-hastus-export').show()
    $(this).text 'Select incidents to export...'
    $('.batch-hastus-export #select-all').show()
    setSelectAllText()

handleIncidentSelected = ->
  selectedIncidentCount = $('.batch-hastus-export input:checked').length
  if selectedIncidentCount > 0
    $('.batch-hastus-export #main-button').text "Generate XML export (#{selectedIncidentCount} selected)"
  else $('.batch-hastus-export #main-button').text 'Select incidents to export...'

selectAllIncidents = ->
  if $(this).text() == 'Deselect all'
    $('.batch-hastus-export input:visible').prop('checked', false).change()
  else $('.batch-hastus-export input:visible').prop('checked', true).change()
  setSelectAllText()

setSelectAllText = ->
  incidentCount = $('.batch-hastus-export input:visible').length
  # if any are unchecked
  if $('.batch-hastus-export input:checked').length < incidentCount
    $('.batch-hastus-export #select-all').text "Select all (#{incidentCount})"
  else $('.batch-hastus-export #select-all').text 'Deselect all'

$(document).on 'turbolinks:load', ->
  $('.batch-hastus-export #main-button').click handleExporting
  $('.batch-hastus-export input').change handleIncidentSelected
  $('.batch-hastus-export #select-all').click selectAllIncidents
