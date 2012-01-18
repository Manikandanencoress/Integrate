$(document).ready(function(){
   $('form .colorpicker').miniColors();
   
   $.tablesorter.addParser({id: 'JustNumber',is: function(s){return false;},
		format: function(s) {return s.replace(/[\,\.]/g,'');
		},
		type: 'numeric'
	});
	
	$("#sort_by").change(function() {
		if(this.value == 4)
		{
			$("#salesreport").tablesorter({ headers: {1: { sorter:'JustNumber'},8: { sorter:'JustNumber'}},sortList:[[4,0],[5,0]] });
		}
		else if(this.value == 5)
		{
			$("#salesreport").tablesorter({ headers: {1: { sorter:'JustNumber'},8: { sorter:'JustNumber'}}, sortList:[[6,0],[7,0]] });
		}
		else if(this.value == 6)
		{
			$("#salesreport").tablesorter({ headers: {1: { sorter:'JustNumber'},8: { sorter:'JustNumber'}},sortList:[[8,0],[9,0]] });
		}     
		else if(this.value == 7)
		{
			$("#salesreport").tablesorter({ headers: {1: { sorter:'JustNumber'},8: { sorter:'JustNumber'}},sortList:[[10,0],[11,0]] });
		}         
		else
		{
			$("#salesreport").tablesorter({ headers: {1: { sorter:'JustNumber'},8: { sorter:'JustNumber'}},
			sortList:[[this.value,0]] });
		}
		$("#salesreport tr:odd").removeClass("odd");
		$("#salesreport tr:even").removeClass("odd");
		$("#salesreport tr:odd").addClass("odd");
		$("#salesreport tr:even").addClass("even");
	});	

	$(".salessortable th").addClass("sort_header");

	$("#salesreport").tablesorter({headers: {1: { sorter:'JustNumber'},8: { sorter:'JustNumber'}},widgets: ["zebra"]});
	
	$("#moviereport").tablesorter({headers: {1: { sorter:'JustNumber'},10: { sorter:'JustNumber'}},widgets: ["zebra"]});
	
	$("#taxreport").tablesorter({headers: {1: { sorter:'JustNumber'},8: { sorter:'JustNumber'}},widgets: ["zebra"]});
	
	$("#movieslist").tablesorter({headers: {1: { sorter:'JustNumber'},9: { sorter:'JustNumber'}},widgets: ["zebra"]});


	$(".salessortable tr").mouseover(function(){
		$(this).addClass("over");
	});
	
	$(".salessortable tr").mouseout(function(){
		$(this).removeClass("over");
	});
  
  $("#studio_id").change(function() {
    var gotourl = '/admin/load_movie/' + this.value
    $.ajax({
    	url: gotourl, type: 'get', dataType: 'script'
	}); 
  });
  $(function () { $("a[rel=twipsy]").twipsy({ live: true }) }) 
  $(function() { $("a[rel=popover]").popover({offset: 10}).click(function(e) {e.preventDefault()})})
});
