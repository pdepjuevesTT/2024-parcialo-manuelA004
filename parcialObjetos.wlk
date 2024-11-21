class Persona{
  const formasDePago = []  // incluye cuentas bancarias que es lo mismo que pagar con debito 
  var formaDePagoPreferida
  const property cosasCompradas = []
  var property dinero
  var property mesActual // numero natural ejemplo 1
  const property cuotas = []
  var property salario

  method modificarSalario(numero){
    salario = salario + numero
  }

  method modificarFormaDePagoPreferida(formaDePago){
    if(formasDePago.contains(formaDePago)){
      formaDePagoPreferida = formaDePago
    }
  }

  method modificarDinero(numero){ //podria usar el property pero me resulta mas comodo de esta manera 
    dinero = dinero + numero
  }

  method esTitular(cuentaBancaria) = formasDePago.contains(cuentaBancaria)

  method comprar(algo){
    if(self.puedeComprar(algo)){
      self.comprarPropio(algo)
      cosasCompradas.add(algo)
    }
  }

  method comprarPropio(algo){
    formaDePagoPreferida.comprar(algo,self)
  }

  method puedeComprar(algo) = formaDePagoPreferida.puedeComprar(algo,self)

  method cobrarSalario(){
    var salarioMes = salario
    self.pagarCuotas()
    self.modificarDinero(salario)
    salario = salarioMes // esto es para que el salario vuelva a ser el mismo despues de pagar las cuotas y de modificar el diner, sto es ais porque al mes siguienete el salario deberia ser el mismo a menos de que en su trabajo lo cambien(?
  }

  method pagarCuotas(){
    cuotas.forEach({cuota => cuota.pagarCuota(self,salario)})
  }

  method transcurreUnMes(){
    mesActual = mesActual + 1
    self.cobrarSalario()
    
  }

  method cuotasVencidas() = cuotas.filter({cuotas => cuotas.vencida(mesActual)})

  method agregarCuotas(cuotasNuevas){
    cuotas.addAll(cuotasNuevas)
  }

  method pagarCuota(cuota){
    self.modificarSalario(-cuota.valorPagar())
  }

}

class Compradorcompulsivo inherits Persona{
  override method puedeComprar(algo) = formasDePago.any({formaDePago => formaDePago.puedeComprar(algo,self)})

  override method comprarPropio(algo){
    formasDePago.find({formaDePago => formaDePago.puedeComprar(algo,self)}).comprar(algo,self)
  }
}

class PagadorCompulsivo inherits Persona{
  override method pagarCuotas(){
    super()
    cuotas.forEach({cuota => cuota.pagarCuota(self,dinero)})
  }

  override method pagarCuota(cuota){//medio rebuscado a mi entender pero no se me ocurrio de otra manera
    if(salario >= cuota.valorpagar()){
      super(cuota)
    }
    else{
      self.modificarDinero(-cuota.valorPagar())
    }
  }
}

class Grupo{ // esto es para poder hacer pasar un mes a un grupo de personas o para ver quien es el que tiene mas cosas compradas 
  const personas = []

  method pasarMes(){
    personas.forEach({persona => persona.transcurreUnMes()})
  }

  method personaConMasCosas() = personas.max({persona => persona.cosasCompradas().size()})
}

class Compra{
  var property precio
}

class FormaDePago{
  method puedeComprar(algo,persona) = self.loPropio(persona) >= algo.precio()

  method loPropio(persona) 
}


object efectivo inherits FormaDePago{
  override method loPropio(persona) = persona.dinero()

  method comprar(algo,persona) { 
    persona.modificarDinero(-algo.precio())
  }
}

class CuentaBancaria inherits FormaDePago{ //seria lo mismo que debito
  var property saldo

  method modificarSaldo(numero) {
    saldo = saldo + numero
  }
  override method loPropio(persona) = saldo
  override method puedeComprar(algo,persona) = persona.esTitular(self) and super(persona,algo)

  method comprar(algo,_persona){
    self.modificarSaldo(-algo.precio())
  }
}


class Credito inherits FormaDePago{
  var maximoPermitido
  var cantidadDeCuotas
  var interes

  override method loPropio(persona) = maximoPermitido

  method comprar(algo,persona){
    const cuotas = self.crearCuotas(algo,persona)
    persona.agregarCuotas(cuotas)
  }

  method crearCuotas(algo,persona) = (1..cantidadDeCuotas).map({numero => self.crearCuota(numero,algo,persona)})

  method crearCuota(numero,algo,persona) = new Cuota(mes = persona.mesActual() + numero,valorPagar = (algo.precio() + self.interes(algo)))

  method interes(algo) = self.calculoPorcentaje(interes,algo)

  method calculoPorcentaje(valor,algo) = valor * algo.precio() / 100
}

class NuevoCredito inherits Credito{ // cuotas con descuento
  var descuento

  override method interes(algo) = super(algo) - self.calculoPorcentaje(descuento,algo)
}

class Cuota{
  var mes = 0
  const property valorPagar


  method puedePagarCuota(persona,pago) = persona.mesActual() >= mes and pago >= valorPagar
  method pagarCuota(persona,metodoPago){
    if(self.puedePagarCuota(persona,metodoPago)){
      self.pagoCuota(persona)
    }
  }

  method pagoCuota(persona){
    persona.pagarCuota(self)
    persona.cuotas().remove(self)
  }

  method vencida(mesActual) = mes <= mesActual
}



