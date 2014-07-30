/*
    @Author          : Accenture
    @Date Created    : 06/07/2012
    @Description     : Custom Styel Sheet sheet to be used in RFA Visualforce pages for custom Styling.
*/

.rightAligned{
    position:absolute;
    left:345px;
}
            
.customPopup{
	background-color: white;
	border-style: solid;
	border-width: 2px;
	left: 50%;
	padding:10px;
	position: absolute;
    z-index: 9999;
    /* These below 3 css properties will need to be tweaked to display the pop up in the center of the screen. Width, margin-left (to negative half of what the width is), and optionally height property for a fixed size pop up.*/
    width: 500px;
    margin-left: -250px;
    top:100px;
}
.sfButtonComponent
{
	color: #333;
	margin: 1px;
	padding: 4px 3px;
	border: 1px solid #b5b5b5;
	border-bottom-color: #7f7f7f;
	background: #e8e8e9 url('/img/alohaSkin/btn_sprite.png') repeat-x right top;
	font-weight:bold;
	font-size: .9em;
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	 border-radius: 3px;
	text-decoration: none;
			  
}