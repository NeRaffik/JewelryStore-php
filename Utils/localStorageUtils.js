class LocalStorageUtils {
    constructor() {
        this.KeyName = 'products';
    }

    getProducts() {
        const productsLocaleStorage = localStorage.getItem(this.KeyName);
        if (productsLocaleStorage !== null) {
            return JSON.parse(productsLocaleStorage);
        }
        return [];
    }

    putProducts(id) {
        let products = this.getProducts();
        let pushProduct = false;
        const index = products.indexOf(id);

        if (index === -1) {
            products.push(id);
            pushProduct = true;
        } else {
            products.splice(index, 1);
        }

        localStorage.setItem(this.KeyName, JSON.stringify(products));

        return { pushProduct, products }
    }
}

const LocalStorageUtil = new LocalStorageUtils();

