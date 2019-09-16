function dofirst(){
	//先跟畫面產生關聯，在建立事件聆聽的功能
	//表單名：theForm
	document.getElementById('theForm').onsubmit = calculate;
}
function calculate(){
	var quantity = document.getElementById('quantity').value;
	var price = document.getElementById('price').value;
	var tax = document.getElementById('tax').value;
	var discount = document.getElementById('discount').value;

	var total = quantity * price;
	tax = tax/100 ;
	tax ++ ;
	total = total*tax;
	total -=  discount ;
	// 取小數後二位 	
	total = total.toFixed(2);
    // Swift or objective 的監聽字串（可自訂），會呼叫到 Swift的中func test3(_ value: String, _ num: Double) 這個方法
    javaScriptCallToSwift.test3("test3", total);
    
	document.getElementById('total').value = total;
	//將算出的值顯示
	return false;
}
window.addEventListener('load',dofirst,false);
/*在js呼叫函數：
	1. 事件聆聽
	2. 計時器 setInterual(函式,毫秒)
*/
/*
HTML DOM
document.
方法
{
	getElementById()
	getElementsByName()
	getElementByTagName()
	getElementByClassName()

	querySelector()    id:#xxx class: .xxx  tag: xxx 
	querySelectorAll()
}
*/ 
