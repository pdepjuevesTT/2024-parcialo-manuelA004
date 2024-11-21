import parcialObjetos.*

describe "test del parcial" {
    const creditoManu = new Credito(maximoPermitido = 100000,cantidadDeCuotas = 6, interes = 2)
    const manu = new Persona(formasDePago = [efectivo,creditoManu], formaDePagoPreferida = creditoManu, dinero = 10000, mesActual = 1, salario = 1000000) //puede cobrar 0 si el trabajo fuera ser ayudante de catedra de pdp 
    const compu = new Compra(precio = 50000)
  test "manu puede comprar una compu" {
    assert.that(manu.puedeComprar(compu))
  }

  test "manu compra la compu y ahora tiene 6 cuotas y la compu"{
    manu.comprar(compu)
    assert.equals(manu.cuotas().size(), 6)
    assert.that(manu.cosasCompradas().contains(compu))
  }

  test "pasa un mes manu paga una cuota, dinero de manu es 959000"{
    manu.comprar(compu)
    manu.transcurreUnMes()
    assert.equals(manu.cuotas().size(),5)
    assert.equals(manu.dinero(),959000)
  }

    const creditoSanti = new Credito(maximoPermitido = 100000,cantidadDeCuotas = 6, interes = 2)
    const santi = new Persona(formasDePago = [efectivo,creditoSanti], formaDePagoPreferida = creditoSanti, dinero = 10000, mesActual = 1, salario = 1) //puede cobrar 0 si el trabajo fuera ser ayudante de catedra de pdp 
    const coampu2 = new Compra(precio = 50000)
  test "santi tiene deudas"{
    santi.comprar(compu)
    santi.transcurreUnMes()
    assert.equals(santi.cuotasVencidas().size(), 1)
  }

}
