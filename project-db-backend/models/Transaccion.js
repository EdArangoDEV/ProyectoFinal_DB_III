const mongoose = require('mongoose');
const transaccionSchema = mongoose.Schema({
    usuarioId: {
        type: Number,
        required: true,
    },
    usuario: {
        type: String,
        required: true
    },
    fecha: {
        type: Date,
        default: Date.now
    },
    tipoTransaccion: {
        type: String,
        required: true
    }
});


module.exports = mongoose.model('Transaccion', transaccionSchema);