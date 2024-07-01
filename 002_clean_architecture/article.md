# Arquitecturas limpias, como desacoplar la lógica de negocio de los detalles de infraestructura

Se dice que una arquitectura es limpia cuando consigue una exitosa separación entre la lógica de negocio y los detalles de la infraestructura. Dicha separación se consigue mediante capas, una fuerte aplicación de los principios SOLID y un estricto cumplimiento de lo que llamaremos "La regla de la dependencia". Hablaremos de ella más adelante.

Según Robert C. Martin, Uncle Bob, estas arquitecturas generan sistemas, productos, que son: 
1. Independientes del framework usado.
2. Con unas reglas comerciales que deben poder ser medibles sin depender de la interfaz del usuario, base de datos, servidor web, etc.
3. Independientes de dicha interfaz de usuario. De hecho, ésta, debería poder ser intercambiable sin afectar a las reglas comerciales, a la anteriormente citada lógica de negocio.
4. Independientes de la base de datos usada, si es que es necesario usarla, independiente del sistema de persistencia de datos, local u online.
5. Independientes, en general, de cualquier interferencia externa. 

> En resumen: Las reglas de negocio no deben de conocer nada de los detalles de infraestructura, para así no depender de estos. 

Más en detalle...

## Lógica de negocio

La llamada lógica de negocio representa el dominio. Se trata de una serie de reglas, acciones y datos que representan nuestro negocio, sus actividades, etc. Por ejemplo, en una aplicación de entrenamientos deportivos, parte de nuestra lógica de negocio serían los modelos destinados a abstraer un entrenamiento, un ejercicio, series, repeticiones, etc. ¿Qué entraría también en nuestra lógica de negocio?, todas aquellas reglas que nos ayuden a definirlo: que un número de series nunca pueda ser negativo, que exista, o no, un descanso entre ejercicios, que el esfuerzo se mida en porcentaje o en rondas hasta el fallo, etc.

La lógica de negocio es común a todos los departamentos de la compañía: marketing, diseño, producto. 

## Detalles de la infraestructura

Aquí hacemos referencia al framework que usamos para diseñar las vistas de nuestra aplicación, la librería de red, el inyector de dependencias, la base de datos, el modelo de persistencia, etc. 

Estos componentes "no tienen vida" fuera de nuestro sistema, nuestra app, nuestra web. Y deberían ser transparentes para el resto de departamentos de la compañía. 

> Mientras que la lógica de negocio varía poco en el tiempo, los detalles de infraestructura sí que pueden verse alterados. En un MVP podemos decidirnos por usar un sistema gestor de base de datos sencillo, poco escalable, y rápido de implementar, ya que solo queremos ver si nuestro producto tiene tracción en el mercado. En caso de funcionar podríamos necesitar cambiarlo. O cambiar el framework mediante el que presentamos la interfaz al cliente porque éste haya sido descontinuado.

> Por ésto último decíamos que las reglas de negocio no debían conocer nada de los detalles de infraestructura, por la alta posibilidad de que estos cambien en el futuro. Implementando una arquitectura limpia podemos conseguir que si necesitamos cambiar alguna parte de nuestra infraestructura, la pieza a cambiar pueda ser sustituida por otra sin afectar a nuestra lógica de negocio, minimizando así el impacto de dichos cambios.

En la siguiente imagen, del [blog de Robert C. Martin (Uncle Bob)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html), podemos ver una representación de capas y responsabilidades que deberían de cumplirse en cualquier arquitectura limpia. 

![representación de capas y responsabilidades](images/ca002.png)

En su artículo de referencia, [aquí](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html), Uncle Bob explica que el número de capas, los círculos, son esquemáticos, que no hay por qué tener "solo" cuatro capas, éstas serían las mínimas. A la hora de crear nuevas capas, o dividir alguna de las actuales, solo tendríamos que tener en cuenta que se siga aplicando la regla de la dependencia. 

## Capas de nuestra arquitectura

¿Cómo podríamos llevarnos esta *clean architecture* a nuestro proyecto con SwiftUI y MVVM?, montémoslo paso a paso.

### Core
---

Contendría el código más estático, aquel del que va a depender el resto. Todas las capas exteriores van a depender de ésta, estarán acopladas a ella, por lo que cualquier cambio en esta capa tendrá repercusiones en el resto de capas de nuestra arquitectura. 

Esta capa no tiene ningún acoplamiento con una capa exterior, es más, no debe conocer ningún componente creado fuera de su propia capa. Esto es lo que denominamos **La regla de la dependencia** y es de obligado cumplimiento para mantener nuestra arquitectura limpia. Y no solo es de obligado cumplimiento para esta capa, también para todas las exteriores, ¿qué nos dice Uncle Bob de la regla de la dependencia?

> **La regla de la dependencia:**  
>
> *La regla primordial que hace que esta arquitectura funcione es la regla de dependencia . Esta regla dice que las dependencias del código fuente sólo pueden apuntar hacia adentro . Nada en un círculo interno puede saber nada acerca de algo en un círculo externo. En particular, el nombre de algo declarado en un círculo exterior no debe mencionarse en el código del círculo interior. Eso incluye funciones, clases, variables o cualquier otra entidad de software.* - Uncle Bob

¿Qué contendría, por ejemplo, esta capa Core?

1. **Modelos de dominio:** abstracción de un entrenamiento, una serie, tipos de entrenamiento, etc
2. **Servicios de dominio:** clases relacionadas con los modelos de dominio y que ayudan a implementar nuestras **reglas de negocio, hablaremos de ellas en la siguiente sección**, por ejemplo, analizar si un ejercicio es válido o no, cambiar el estado de un array de ejercicios, sumar una repetición si estás repitiendo un ejercicio que ya hubieses realizado, comprobar que el número de repeticios ha de ser mayor de cero...  

> No confundir estos servicios de dominio con una clase que, por ejemplo, realice una petición de red para recibir datos del entrenamiento, o que envíe algún tipo de evento fuera.

Nuestos modelos de dominio también los encontrarás citados, aquí o en otros artículos, charlas, etc, como **Entities** o **Data Objects**. Veamos una representación de esta capa.

![Capa core](images/CoreLayer.png)

Los componentes de esta capa solo pueden tener dependencias entre ellos, tanto de los modelos como de los servicios, ya que están en la misma capa. Como podemos apreciar en esta representación, nuestra capa **core** no conoce nada fuera de su capa, no hay una capa inferior de la que dependa.

¿Qué tipo de acoplamiento podríamos tener en esta capa?, pues por ejemplo: la abstracción *Entrenamiento* podría tener una dependencia con *Ejercicio* al tener que gestionar una colección de éstos.

### Lógica de negocio
---

Esta capa contendría las reglas comerciales específicas de nuestra aplicación. Por convención, al software que diseñamos en esta capa se le llama **Casos de Uso**. Los usamos para dirigir el flujo de datos desde nuestras entidades y hacia éstas. 

**¿Reglas comerciales?, ¿Reglas de negocio?, ¿de qué nos estás hablando?, veámoslo mejor con ejemplos...** 

1. Reglas de negocio para la tarea: *Consultar el historial de entrenamientos*
    * Filtrar las sesiones de entrenamiento por usuario y rango de fechas (si se proporciona)
    * Ordenar las sesiones por fecha.
    * Calcular estadísticas relevantes (por ejemplo, total de ejercicios realizados, tiempo total de entrenamiento).
2. Reglas de negocio para la tarea: *Actualizar perfil de usuario*
    * Validar la consistencia de la información proporcionada.
3. Reglas de negocio para la tarea: *Registrar una sesión de entrenamiento*
    * Verificar que el plan de entrenamiento existe y pertenece al usuario.

> *Consultar el historial de entrenamientos*, por ejemplo, tendría su propio caso de uso y sería el encargado de llevar a cabo la implementación de nuestras reglas de negocio. ¿Cómo podría evitar incumplir el principio de responsabilidad única?, podría apoyarse en otros casos de uso, en caso de necesitarlos, usar los *servicios de dominio* que vimos en la sección anterior, etc.

Los cambios en esta capa no afectarían a nuestros modelos de dominio y tampoco deberían verse afectados por cambios externos. ¿Cómo mantenemos nuestra *regla de la dependencia*?. Los casos de uso establecerán sus *contratos*, *protocolos*, *interfaces*, como queramos llamarlos, y serán implementados por los componentes de la capa superior.

Estos protocolos habitan en la misma capa que los casos de uso, ya que pertenecen a nuestra lógica de negocio. 

Dicho todo esto, nuestros casos de uso tendrían dependencias de: 
1. Nuestros modelos, y servicios, de dominio, que se encuentran en una capa inferior.
2. Otros casos de uso. Un caso de uso podría necesitar información que obtuviese mediante otro. 
3. Los protocolos, interfaces, que implementan o de los que tienen dependencias por composición. 

¿Cómo quedaría nuestra representación de capas?

![Capas de dominio](images/DomainLayers.png)

He dibujado la dependencia de esta capa, con la capa inferior, mediante una flecha hacia dentro del gráfico. Lo veréis así en el resto del artículo, y también con el resto de capas.

### Adaptadores
---

Los adaptadores establecen un puente entre la lógica de negocio y los detalles de infraestructura. Aquí se encuentran los componentes que implementan los contratos, protocolos, interfaces, definidos en la capa inferior (Casos de uso).

Esta capa también se ocupa de "traducir", mapear, los datos que obtenemos desde capas externas a datos de nuestra lógica de negocio.

La capa de adaptadores estaría dividida en varias secciones, cómo mínimo, estas dos:
1. **Capa de presentación:** donde encontraríamos los viewmodels, presenters, etc
2. **Capa de datos:** donde encontraríamos los repositorios, protocolos de datasource, mappers, protocolos de Data Objects, etc

Hay un cambio importante con relación a las capas inferiores. En éstas todos sus componentes se "conocían" entre sí y podían depender unos de otros. En la capa **Adaptadores** esto no es posible, y es muy importante que se cumpla esta regla. Los componentes de la capa de presentación no pueden tener ningún tipo de dependencia de componentes de la capa de datos y viceversa, no pueden estar acoplados. 

Un ViewModel no podría, por ejemplo, instanciar un objeto de la capa de datos, tendría que hacerlo a través de los casos de uso, a través de su capa inferior. Son flujos que están separados. Ayúdemonos de una representación gráfica:

![Flujo de datos e interacciones en nuestra clean architecture](images/cleanarchitectureflow.png)

> La capa de adaptadores podría estar dividida en más partes, secciones. He citado estas dos porque considero que son las más comunes a cualquier arquitectura limpia, independientemente de la tecnología del proyecto, sea web, app, etc...
> 
> Por ejemplo, un manager que gestionase la analítica de nuestro negocio, aplicación, etc, también pertenecería a esta capa de adaptadores. Y al igual que las capas de presentación y datos no podría tener dependencias con éstas. 

![Capa de adaptadores](images/AdaptersLayer.png)

Podemos observar cómo la capa de adaptadores está acoplada a la de use cases, así como ésta lo está a la de dominio. Nada definido aquí, en la capa de adaptadores, podría ser "invocado" en la capa de use cases. Para eso usamos el principio de la inversión de dependencias, implementamos en nuestros componentes los protocolos necesarios, que tenemos definidos en la capa inferior, y los inyectamos donde sea necesario.

### Capa de infraestructura
---

Al principio del artículo hablábamos sobre que había que separar la lógica de negocio de los detalles de la infraestructura, hasta ahora habíamos visto la lágica de negocio, mediante sus capas contenedoras de las entidades y casos de uso. Y también habíamos hablado de una capa, adaptadores, que hacía de puente entre ésta lógica la capa de infraestructura. Hablemos de ésta última.

Esta capa contendría todos los componentes relacionados con la interfaz de usuario, por ejemplo, las vistas en SwiftUI o UIKit. Contendría las clases necesarias para realizar una llamada de red y obtener los datos que necesitamos inyectar en nuestros repositorios para que éstos, a su vez, lo hagan en los casos de uso. Para ello usaríamos URLSession, Alamofire, Moya, o similar. En caso de tener que persistir datos sería esta capa la que se encargaría de implementar la funcionalidad mediante una base de datos local (sqlite, coredata, swiftdata...)

Fijáos en la diferencia de esta capa con las más internas. Aquí ya estamos hablando de tecnologías, frameworks, etc. Mientras antes hablábamos de entrenamientos, ejercicios, repeticiones, ahora hablamos de SwiftUI, URLSession o CoreData...

Esta es la parte que es más susceptible de sufrir cambios durante la vida de un proyecto. Mediante nuestra arquitectura limpia conseguimos que un cambio en cualquier componente de esta capa no tenga ninguna repercusión en las capas inferiores, en nuestra lógica de negocio. Si tenemos que cambiar alguno de estos componentes estará tan aislado que el cambio se limitará a sustiuir un componente por otro, sin que el resto de componentes deba sufrir ninguna alteración. 

Nuevamente conseguimos esta capacidad de fácil sustitución mediente el uso de los principios solid y su inversión de las dependencias.

¿Echamos un vistazo a la representación final de nuestra arquitectura?

![capa infraestructura, rodeando el resto](images/InfrastructureLayer.png)

> Esta capa tiene la misma particularidad que la capa adaptadores, aunque las vistas están en la misma capa que los *data sources* éstos no se *"conocen"*, no tienen dependencias entre ellos ni por herencia ni por composición. En resumen, no están acoplados entre ellos. 

