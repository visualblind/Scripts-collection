
function ir_url(url,url2){
    if (url!='') {
        if (top.work && top.work.events) 
	    top.work.events.location.href = url;
	else 
	    window.open(url);
    }
	
    if (url2!='') {
        if (top.work && top.work.map) 
            top.work.map.location.href = url2;
        else
    	    if (top.work) 
	        top.work.location.href = url2;
	    else 
		window.open(url2);
    }
}

function show_objects_debug() {
    for (i = 0;i < objects.length;i++)
	if (objects[i]) {
	    debug ("Object "+i+", X: "+objects[i][2]+", Y: "+objects[i][3]);
	    for (j = 0;j < objects[i][1].length;j++)
		if (objects[i][1][j]) debug("Object "+i+", with Line "+j+", to "+objects[i][1][j]);
	}
}

function real_debug (data) {
    if (!document.all) debugtext = document.getElementById("debugtext");
    debugtext.innerHTML = debugtext.innerHTML + "<br>" + data;
}

function link_to_object(id) {
    selected_name = null;
    
    if (link_to_a==null) link_to_a = id;
    else {
        if (id)
	    if ((link_to_a!=id) || (confirm("Are you sure you want to delete all conections from this interface?"))) {
		new_link(link_to_a,id);
	        setTimeout("document.location.reload();",1000);
		debug ("Link From "+link_to_a+" to "+id);
	    }
	link_to_a = null;
    }
    debug ("Link From "+link_to_a);
}
 
function select_object(name) {
    if (selected_name != null) {
	if (was_moved!=null) {
	    debug ("saving position "+was_moved);
	    redraw_connections (selected_name);
	    save_object(selected_name);
	}
	selected_name = null;
    } else {
	selected_name = name;
    }
    debug("selected "+selected_name);
}

function select_object_by_mouse(event) {
    select_object(object_by_pos (event.clientX, event.clientY));
}

function object_by_pos(x,y) {
    for (var i = 0;i < objects.length;i++)
	if (objects[i])
	    if (
		(x > objects[i][2]-(sizex/2)) &&
		(x < objects[i][2]+(sizex/2)) &&
		(y > objects[i][3]-(sizey/2)) &&
		(y < objects[i][3]+(sizey/2)) &&
		(x < (totalx-(sizex/2)))      && 
		(y < totaly) 		) return i;
    return false;
}

function redraw_all_connections () {
    for (i = 0;i < objects.length;i++)
	if (objects[i]) redraw_connections (i);
    already_lines = null;
}

function position_new_objects () {
    sepx = Math.floor(sizex+gridx);
    sepy = Math.floor(sizey+gridy);
    maxx = Math.floor((totalx / sepx))-1;
    posx=0;
    posy=0;
    var i;
    new_objects_found = 0;
        
    for (i = 0;i < objects.length;i++)
	if (objects[i])
	    if (objects[i][2] < 5) {
		do { 
		    x = (posx*sepx)+(sizex/2)+10;
		    y = (posy*sepy)+20;

		    //debug ("New "+i+", X: "+x+"("+posx+"), Y: "+y+"("+posy+")");
		    if (++posx>maxx) {
			posx=0;
			posy++;
		    }
		} while (object_by_pos(x,y)!=false);
	
		move_object(i,x,y);
		//debug ("Moved "+i+", X: "+x+"("+posx+"), Y: "+y+"("+posy+")");
		new_objects_found = 1;
		objects_to_save[objects_to_save_id++]=i;
	    }

    if (new_objects_found==1) save_new_objects(0);
}


function redraw_connections (id) {
    for (j = 0;j < objects[id][1].length;j++) 
	if ((objects[id][1][j]) && ((!already_lines) || (already_lines[j]!=1))) {
	    //debug("Object "+id+" connected to "+objects[id][1][j]+" with Line "+j);
	    id2 = objects[id][1][j];
	
	    if (!document.all) 	line = document.getElementById("conexion"+j);
	    else 		eval("line = document.all.conexion"+j+";");
	
	    line.src="views/view_dynmap_line.php?totalx="+totalx+"&totaly="+totaly+"&con[]="+objects[id][2]+","+objects[id][3]+","+objects[id2][2]+","+objects[id2][3];
	    if (already_lines) already_lines[j]=1;
    }
}

function draw_all_connections () {
    var url = "";
    var cnx = 0;

    for (id = 0;id < objects.length;id++)
	if (objects[id])
	    for (j = 0;j < objects[id][1].length;j++) 
		    if (objects[id][1][j]) {
			//debug("Object "+id+" connected to "+objects[id][1][j]+" with Line "+j);
			id2 = objects[id][1][j];
	
			url=url+"&con["+cnx+"]="+objects[id][2]+","+objects[id][3]+","+objects[id2][2]+","+objects[id2][3];
			cnx++;
		    }

    if (url!="") {
	if (!document.all) 	allconexions = document.getElementById("allconexions");
	allconexions.src="views/view_dynmap_line.php?totalx="+totalx+"&totaly="+totaly+url;
    }
}

function follow_object (event) {
    move_object(selected_name,event.clientX,event.clientY);
}

function move_object (id,x,y) {
    if ((id) && (id!=null)) {
      	if (!document.all) 	object = document.getElementById("object"+id).style;
	else 			eval("object = document.all.object"+id+".style;");

	if (object) 
	    if (x < (totalx-(sizex/2)) && (y < totaly)) {
		x=(Math.floor(x/gridx))*gridx;
		y=(Math.floor(y/gridy))*gridy;
		
		object.left = x-(sizex/2);
		object.top = y-(sizey/2);
		objects[id][2]=x;
		objects[id][3]=y;
		//redraw_connections (id); //follow
		was_moved = true;
		//debug ("Moved Object "+id+" to X: "+x+" Y: "+y);
	    }
    }
    //debug("X: "+event.clientX+" Y: "+event.clientY);
}

function save_object (id){
    save_url (document.location+"&action=save&update[]="+objects[id][0]+","+objects[id][2]+","+objects[id][3]);
}	

function new_link (id1,id2){
    save_url (document.location+"&action=save&update[]=1,"+id1+","+id2);
}	

function save_new_objects (part) {

    parts = 2;
    if (objects_to_save.length < 50) parts = 1;

    cant = objects_to_save.length/parts;

    debug ("Save part "+part+" of "+parts+" parts "+cant+" items each");

    if (part==0) 
	for (j = 0; j < parts; j++)
	    setTimeout("save_new_objects("+(j+1)+");",1000*(j+1));
    else {
	url = '';
        for (i = 0; i < cant; i++) {
	    id = objects_to_save[i+((part-1)*cant)];
	    //debug ("part "+part+" i "+i+" id "+id+" "+objects[id][0]+","+objects[id][2]+","+objects[id][3]);
            url = url + "&update[]="+objects[id][0]+","+objects[id][2]+","+objects[id][3];
	}

	if (url!='') {  
    	    debug ("Saving Part "+part+" of "+cant+" new objects positions");
    	    save_url(document.location+"&action=save"+url);
	}
    }
}

function save_url (url){
    url = url + "&debug=0";
    if (!document.all) {
	savebox = document.getElementById("savebox");
	savebox.src=url;
    } else 
	savebox.document.location = url;
}
