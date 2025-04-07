const mongoose = require('mongoose');
const CambiosProductosSchema = mongoose.Schema({
    usuarioId :{
        type: Number,
        required: true,
    },
    usuario :{
        type: String,
        required: true
    },
    fecha :{
        type: Date,
        default: Date.now
    },
    tipoTransaccion :{
        type: String,
        required: true
    },
    cod_producto :{
        type: String,
        required: true
    },
});


module.exports = mongoose.model('CambiosProductos', CambiosProductosSchema);
