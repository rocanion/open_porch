function draw_chart(options) {
  chart = new Highcharts.Chart({
     chart: {
        renderTo: 'chart-container',
        defaultSeriesType: 'line'
     },
     title: null,
     xAxis: {
        categories: options.days,
        tickInterval: 1+(parseInt(options.days.length/30)) // 30 days => interval is 1, 60 days => 2, 90 days => 3... etc
     },
     yAxis: {
        title: { text: 'Count' },
        min: 0
     },
     tooltip: {
        formatter: function() {
          return '<b>'+ this.x.replace('<br/>', '/') +'</b><br/>' + this.y + ' ' + this.series.name;
        }
     },
     legend: {
       enabled: true,
       symbolWidth: 5,
       itemStyle: { fontSize: '10px'}
     },
     series: options.series,
  });

}