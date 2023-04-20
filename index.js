function render(){
    const productsStore = LocalStorageUtil.getProducts();
    
    headerPage.render(productsStore.length);
    productsPage.render();

}

spinnerPage.render();

let CATALOG = [];

//https://api.myjson.online/v1/records/d9537e83-d34f-44e2-9c27-85a0f8951740
fetch("ajax.php",{//'server/launch.json'
        method: 'POST', // GET, PUT, DELETE
        headers: {
            'Content-type': 'application/json; charset=UTF-8',
            },
        }
)
.then((response) => response.json())
.then((data) => {
    console.log(data);
    CATALOG = data;
    
    spinnerPage.handleClear();
	
    render();
})
.catch((err) => {
    spinnerPage.handleClear();
    errorPage.render();
    console.log('ошибка' + err); 
});

