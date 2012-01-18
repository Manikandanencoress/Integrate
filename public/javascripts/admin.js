$(document).ready(function(){
   $.tablesorter.addParser({id: 'JustNumber',is: function(s){return false;},
        format: function(s) {return s.replace(/[\,\.]/g,'');
        },
        type: 'numeric'
    });
   $('form .colorpicker').miniColors();
   
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
  $(".salessortable tr").mouseover(function(){
      $(this).addClass("over");
    });
  $(".salessortable tr").mouseout(function(){
      $(this).removeClass("over");
    });
});
