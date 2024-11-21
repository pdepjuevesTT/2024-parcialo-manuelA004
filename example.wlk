class Persona{
  const formasDePago = []  // incluye cuentas bancarias
  var formaDePagoPreferida
  const cosasCompradas = []
  var property dinero
  var mesActual // numero natural ejemplo 8
  const cuotas = []
  var salario

  method modificarSalario(numero){
    salario = salario + numero
  }

  method modificarDinero(numero){ //podria usar el property pero me resulta mas comodo de esta manera 
    dinero = dinero + numero
  }

  method esTitular(cuentaBancaria) = formasDePago.contains(cuentaBancaria)

  method comprar(algo){
    if(self.puedeComprar(algo)){
      formaDePagoPreferida.comprar(algo,self)
      cosasCompradas.add(algo)
    }
  }

  method puedeComprar(algo) = formaDePagoPreferida.puedeComprar(algo,self)



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

class Cuota{
  var mes = 0
  const valorPagar

  method mes() =if(mes > 12){mes -12} else{mes}
}


