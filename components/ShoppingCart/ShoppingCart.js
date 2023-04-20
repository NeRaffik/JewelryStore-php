class ShoppingCart{

    handlerClear(){
        productsPage.render();
        ROOT_SHOPPINGCART.innerHTML = '';
    }

    handlerSetLocatiomStorage(element,id){
        productsPage.handlSetLocationStorage(element,id);

        shoppingPage.render();
    }

    render(){
        const productsStore = LocalStorageUtil.getProducts();
        let htmlCatalog = '';
        let sumCatalog = 0;


        CATALOG.forEach(({Id,ProductName,ProductPrice}) => {
            if(productsStore.indexOf(Id) !== -1){
                htmlCatalog += `
                    <tr>
                        <td class="shopping-element__name">${ProductName}</td>
                        <td class="shopping-element__price">${parseInt(ProductPrice).toLocaleString()} ₽</td>
                        <td>
                            <button class="shopping-element__btn btn_select" onclick="shoppingPage.handlerSetLocatiomStorage(this,'${Id}');">
                                Удалить из корзины
                            </button>
                        </td>
                    </tr>
                `;
                sumCatalog += parseInt(ProductPrice);
            }
        });

        const html = `
            <div class="shopping-container">
                <div class="shopping__close" onclick="shoppingPage.handlerClear();"></div>
                <table>
                    ${htmlCatalog}
                    <tr>
                        <td class="shopping-element__name">Сумма:</td>
                        <td class="shopping-element__price">${sumCatalog.toLocaleString()} ₽</td>
                    </tr>
                </table>
            </div>
        `;

        ROOT_SHOPPINGCART.innerHTML = html;
    }
}

const shoppingPage = new ShoppingCart();