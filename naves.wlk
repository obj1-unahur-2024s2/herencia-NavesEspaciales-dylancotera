class Nave{
  var velocidad
  var direccion
  var combustible

  method acelerar(cuanto){
    velocidad = (velocidad + cuanto).min(100000)
  }

  method desacelerar(cuanto){
    velocidad = (velocidad - cuanto).max(0)
  }

  method irHaciaElSol(){
    direccion = 10
  }

  method escaparDelSol(){
    direccion = -10
  }

  method ponerseParaleloAlSol(){
    direccion = 0
  } 

  method acercarseUnPocoAlSol(){
    direccion = (direccion + 1).min(10)
  }

  method alejarseUnPocoDelSol(){
    direccion = (direccion - 1).max(-10)
  }

  method prepararViaje()

  method cargar(cantidad){ 
    combustible += cantidad 
  }
  
  method descargar(cantidad) { 
    combustible = (combustible - cantidad). max(0) 
  }

  method accionAdicionalViaje(){
    self.cargar(30000) 
    self.acelerar(5000)
  }

  method estaTranquila() = combustible >= 4000 && velocidad < 12000
  
  method recibirAmenaza(){
    self.escapar()
    self.avisar()
  }  
  
  method escapar()

  method avisar()
 
  method estaDeRelajo() = self.estaTranquila() && self.tienePocaActividad()

  method tienePocaActividad() = true
}

class NaveBaliza inherits Nave{
  var colorActual 
  var cambioDeColor = false

  method cambiarColorDeBaliza(colorNuevo){
    if(not ["verde" , "rojo", "azul"].contains(colorNuevo) ){
      self.error("Color no permitido")  
    }
    colorActual = colorNuevo
    cambioDeColor = true
  }

  override method prepararViaje(){
    self.cambiarColorDeBaliza("verde")
    self.ponerseParaleloAlSol()
    self.accionAdicionalViaje()
  }

  override method estaTranquila() = super() && colorActual != "rojo"

  override method escapar(){
    self.irHaciaElSol()
  }

  override method avisar(){
    colorActual = "rojo"
  }

  override method tienePocaActividad() = not cambioDeColor

}


class NavePasajero inherits Nave{
  var cantidadPersonas
  var racionesComida
  var racionesBebida
  var comidaServida = 0

  method agregarPasajeros(unaCantidad){
    cantidadPersonas += unaCantidad
  }

  method cargarComida(unaCantidad){
    racionesComida += unaCantidad
  }
  
  method cargarBebida(unaCantidad){
    racionesBebida += unaCantidad
  }  

  method descargarComida(unaCantidad){
    racionesComida = (racionesComida - unaCantidad).max(0)
    comidaServida = (comidaServida + unaCantidad).min(racionesComida)
  }

  method descargarBebida(unaCantidad){
    racionesBebida = (racionesBebida - unaCantidad).max(0)
  }

  override method prepararViaje(){
    self.cargarComida(4 * cantidadPersonas)
    self.cargarBebida(6 * cantidadPersonas)
    self.acercarseUnPocoAlSol()
    self.accionAdicionalViaje()
  }

  override method escapar(){
    velocidad * 2 
  }

  override method avisar(){
    self.descargarComida(cantidadPersonas)
    self.descargarBebida(cantidadPersonas * 2)
  }

  override method tienePocaActividad() = comidaServida > 50
}

class NaveHospital inherits NavePasajero{
  var tieneQuirofanosPreparados

  method tieneQuirofanosPreparados() = tieneQuirofanosPreparados

  override method estaTranquila() = super() && not tieneQuirofanosPreparados
  
  override method recibirAmenaza(){
    super()
    tieneQuirofanosPreparados = true
  }

}


class NaveCombate inherits Nave{
  var estaInvisible
  var misilesDesplegados
  const property mensajesEmitidos = []
  
  method estaInvisible() = estaInvisible
  method ponerseVisible() { 
    estaInvisible = true
  }
  method ponerseInvisible() { 
    estaInvisible = false 
  }
  
  method misilesDesplegados() = misilesDesplegados

  method desplegarMisiles() { 
    misilesDesplegados = true 
  }
  method replegarMisiles() { 
    misilesDesplegados = false 
  }

  method emitirMensaje(mensaje) { 
    mensajesEmitidos.add(mensaje)
  }

  method primerMensajeEmitido() = mensajesEmitidos.first()

  method ultimoMensajeEmitido() = mensajesEmitidos.last()

  method esEscueta() = not mensajesEmitidos.any({ m => m.size() > 30 })
  
  method emitioMensaje(mensaje) = mensajesEmitidos.contains(mensaje)

  override method prepararViaje(){
    self.ponerseVisible()
    self.replegarMisiles()
    self.acelerar(15000)
    self.emitirMensaje("Saliendo en Mision")
    self.accionAdicionalViaje()
  }

  override method accionAdicionalViaje(){
    super()
    self.acelerar(15000)
  }

  override method estaTranquila() = super() && not misilesDesplegados 
  
  override method escapar(){
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }

  override method avisar(){
    self.emitirMensaje("Amenaza recibida")
  }
}

class NaveCombateSigilosa inherits NaveCombate{
  
  override method estaTranquila() = super() && not estaInvisible

  override method escapar(){
    super()
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
}