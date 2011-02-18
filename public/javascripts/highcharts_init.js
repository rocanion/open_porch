function draw_chart(options) {  
  chart = new Highcharts.Chart({
     chart: {
        renderTo: 'chart-container',
        defaultSeriesType: 'line',
        marginRight: 130,
        marginBottom: 100,
        marginTop: 20
     },
     title: null,
     xAxis: {
        categories: options.days
     },
     yAxis: {
        title: { text: 'Count' },
        min: 0
     },
     tooltip: {
        formatter: function() {
          return '<b>'+ this.series.name +'</b><br/>'+this.x +': '+ this.y;
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