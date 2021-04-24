var oid = 0;

function infobox_show(image,event,content) {
    if (document.all) {
	info=document.all.infobox;
	infostyle=document.all.infobox.style;
	w = document.body.scrollWidth;
	h = document.body.scrollHeight;
	x = event.clientX;
	y = event.clientY;
    } else {
        info = document.getElementById("infobox").style;
	infostyle = document.getElementById("infobox").style;
	text = document.getElementById("text");
	w = document.width;
	h = document.height;
	x = image.x;
	y = image.y;
    }

    if (x>(w/2)) 
	infostyle.left=x-150;
    else 
	infostyle.left=x+50;

    if (y>(h/2)) 
	infostyle.top=y-75;
    else 
	infostyle.top=y+30;

    text.innerHTML=content;
    infostyle.visibility="visible";

    if (oid!=0)
	toolbox_hide (oid);

    var a = new String(image.alt).split(' ');
    oid = a[1];
    
    if (y > (h/2))
	toolbox_show(oid,x,image.width,y+image.height);
    else
	toolbox_show(oid,x,image.width,y-16);
    
    return true;
}

function infobox_hide() {
    window.setTimeout ('infostyle.visibility="hidden"',15*1000);
    window.setTimeout ('toolbox_hide('+oid+');',15*1000);
    return true;
}
