
function toolbox_get (id) {

    name = "t"+id;

    if (document.all) {
	toolbox = document.all[name];
	if (toolbox) 
	    return document.all[name].style;
    } else { 
	toolbox = document.getElementById(name);
	if (toolbox) 
	    return document.getElementById(name).style;
    }
}

function toolbox_show (id,x,w,y) {
    
    if (toolbox_style = toolbox_get(id)) {
	toolbox_style.visibility = 'visible';
        toolbox_style.left = x+w-90;
        toolbox_style.top = y;
    }
}

function toolbox_hide (id) {
    
    if (toolbox_style = toolbox_get(id))
	toolbox_style.visibility = 'hidden';
}
