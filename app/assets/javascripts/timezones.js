(function() {
  document.addEventListener("DOMContentLoaded", function() {
    var color, ctx, data, ele;
    ele = document.getElementById('timezone-chart');
    if ( !ele ) return;
    color = window.getComputedStyle(document.getElementsByClassName('has-text-primary')[0]).color;
    data = {
      labels: JSON.parse(ele.dataset.zones),
      datasets: [
        {
          data: JSON.parse(ele.dataset.counts),
          backgroundColor: color.replace(')', ', 0.6)').replace('rgb', 'rgba'),
          hoverBackgroundColor: color
        }
      ]
    };
    ctx = ele.getContext('2d');
    new Chart(ctx, { type: 'bar', data: data,
      options: {
        plugins: {
          legend: { display: false },
          tooltip: { displayColors: false },
        },
        scales: {
          xAxis: {
            grid: { display: false },
            ticks: { fontSize: 9, fontColor: '#bbb' }
          },
          yAxis: {
            grid: { display: false },
            ticks: { drawTicks: true }
          }
        }
      }
    });
  });

}).call(this);
