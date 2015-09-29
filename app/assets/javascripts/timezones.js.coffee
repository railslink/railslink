$ ->
  data = {
    labels: $('#timezone-chart').data('zones'),
    datasets: [{ 
      data: $('#timezone-chart').data('counts'),
      fillColor: $('.num').css('color').replace(')', ', 0.6)').replace('rgb', 'rgba'),
      highlightFill: $('.num').css('color'),
    }]
  }
  ctx = $('#timezone-chart').get(0).getContext('2d')
  timezoneChart = new Chart(ctx).Bar(data, {
    scaleShowVerticalLines: false,
    barShowStroke : false
    barValueSpacing : 1,
    animation: false,
    responsive: true,
    scaleShowLabels: false
    scaleShowGridLines : false
    scaleFontColor: '#bbb'
    scaleFontSize: 8
  })
