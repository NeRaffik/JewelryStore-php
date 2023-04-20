class Products{

    constructor(){
        this.classNameActive = 'products-element__btn_active';
        this.lableAdd = 'Добавить в корзину';
        this.lableRemove = 'Удалить из корзины';
    }
    
    handlSetLocationStorage(element, id){
        const { pushProduct, products } = LocalStorageUtil.putProducts(id);

        if (pushProduct) {
            element.classList.add(this.classNameActive);
            element.innerHTML = this.lableRemove;
        } else {
            element.classList.remove(this.classNameActive);
            element.innerHTML = this.lableAdd;
        }

        headerPage.render(products.length);
    }

    // openProductPage(id){
    //     productPage.render(id);
    // }

    render(){
        const productsStore = LocalStorageUtil.getProducts();
        let htmlCatalog = '';

        CATALOG.forEach(({Id,ProductName,ImagePath,ProductPrice}) => {
            let activeClass = '';
            let activeText = '';

            if (productsStore.indexOf(Id) === -1) {
                activeText = this.lableAdd;
            } else {
                activeText = this.lableRemove;
                activeClass = ' ' + this.classNameActive;
            }

            htmlCatalog += `
              <li class="products-element">
                <span class="products-element__productName">${ProductName}</span>
                <img class="products-element__img" src = "${ImagePath}" /> 
                <span class="products-element__price">
                    ${parseInt(ProductPrice).toLocaleString()} ₽ 
                </span>
                <button class="products-element__btn${activeClass}" onclick="productsPage.handlSetLocationStorage(this,'${Id}');">
                    ${activeText}
                </button>
              </li>  
            `;
        });

        const html = `
            <ul class="products-container">
                ${htmlCatalog}
            </ul>
        `;

        ROOT_PRODUCTS.innerHTML = html;
    }
}

const productsPage = new Products();
//productsPage.render();