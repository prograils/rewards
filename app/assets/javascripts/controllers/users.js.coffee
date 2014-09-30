$ ->
  change_period = ->
    month = $('#date_month').find(":selected").val()
    year = $('#date_year').find(":selected").text()
    $.ajax({
    type: "PUT",
    url: "/change_period",
    data: { month: month, year: year }
    });
  $('#date_month').change ->
    change_period()
  $('#date_year').change ->
    change_period()
