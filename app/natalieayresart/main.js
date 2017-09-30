		function openNav() {
			if(this.id != "hiddenshowcase" && this.id != "null"){
    			console.log(this);
			$('#hiddenshowcase').children('img').attr("src", $('#' + this.id).children("img").attr('src'));
			$('#hiddenshowcase').children('p').html($('#' + this.id).children("p").html());
    			document.getElementById("myNav").style.display = "block";
    			$('#hiddenshowcase').children('h3').html(this.id);
    			$('#hiddenshowcase').children('button').val(this.id + '|' + $('#' + this.id).children("img").attr('src'));
    			}
		}

		function closeNav() {
    			document.getElementById("myNav").style.display = "none";
		}
window.onload(function(){
	var products = $('img');
	for(var index = 0; index < products.length; index++){
		console.log(products[index]);
		products[index].addEventListener("click", openNav);
	}
});