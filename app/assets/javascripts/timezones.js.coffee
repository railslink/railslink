$ ->
  data = {
    labels: $("#timezone-chart").data('zones'),
    datasets: [{ 
      data: $("#timezone-chart").data('counts'),
      fillColor: $('.num').css('color').replace(')', ', 0.6)').replace('rgb', 'rgba');
    }]
  }
  ctx = $('#timezone-chart').get(0).getContext("2d")
  myBarChart = new Chart(ctx).Bar(data, {
    scaleShowVerticalLines: false,
    barValueSpacing : 0,
    animation: false,
    responsive: true
  })
