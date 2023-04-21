class Product {

    handlerClear() {
        //productsPage.render();
        ROOT_PRODUCT.innerHTML = '';
    }

    render(element) {

        spinnerPage.render();
        
        let CATALOG = [];

        fetch("ajaxProductsList.php", {
            method: 'POST',
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

        const html = `
            <div class="product-container">
                <div class="product__close" onclick="productPage.handlerClear();"></div>
                <div>
                    ${element.Id}
                </div>
            </div>
        `;

        ROOT_PRODUCT.innerHTML = html;
    }
}

const productPage = new Product();