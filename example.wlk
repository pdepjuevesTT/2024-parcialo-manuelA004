class Persona{
  const formasDePago = []  // incluye cuentas bancarias
  var formaDePagoPreferida
  const property cosasCompradas = []
  var property dinero
  var mesActual // numero natural ejemplo 1
  const cuotas = []
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
    salario = salarioMes
  }

  method pagarCuotas(){
    cuotas.forEach({cuota => cuota.pagarCuota(self,salario)})
  }

  method transcurreUnMes(){
    self.cobrarSalario()
    mesActual = mesActual + 1
  }

  method cuotasVencidad() = cuotas.filter({cuotas => cuotas.vencida(mesActual)})



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
}

class Grupo{
  const personas = []

  method pasarMes(){
    personas.forEach({persona => persona.transcurreUnMes()})
  }

  method personaConMasCosas() = personas.max({persona => persona.cosasCompradas().size()})
}

class Compras{
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
    persona.agregarCutoas(cuotas)
  }

  method crearCuotas(algo,persona) = (1..cantidadDeCuotas).map({numero => self.crearCuota(numero,algo,persona)})

  method crearCuota(numero,algo,persona) = new Cuota(mes = persona.mesActual() + numero,valorPagar = (algo.precio() + self.interes(algo)))

  method interes(algo) = algo.precio() * interes / 100
}

class NuevoCredito inherits Credito{
  var inflacion 
}

class Cuota{
  var mes = 0
  const valorPagar

  method pagarCuota(persona,medioDePago){
    if(persona.mesActual() >= mes and medioDePago >= valorPagar){
      persona.medioDePago(persona.medioDePago()-valorPagar)
      persona.cuotas().remove(self)
    }
  }

  method vencida(mesActual) = mes >= mesActual
}


