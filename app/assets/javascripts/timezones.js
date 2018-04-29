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
        legend: { display: false },
        tooltips: { displayColors: false },
        scales: {
          xAxes: [
            {
              gridLines: { display: false },
              ticks: { fontSize: 9, fontColor: '#bbb' }
            }
          ],
          yAxes: [
            {
              gridLines: { display: false },
              ticks: { display: false }
            }
          ]
        }
      }
    });
  });

}).call(this);
