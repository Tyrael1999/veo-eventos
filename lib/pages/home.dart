import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:veo_eventos/app_state.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    appState.getEvents();

    List<Color> cardColors = [
      Colors.green,
    ]; // Tu lista de colores para el swiper

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          CarouselSlider.builder(
            itemCount: appState
                .events.length, // Usamos la longitud de la lista de eventos
            itemBuilder: (BuildContext context, int index, int realIndex) {
              var event = appState.events[
                  index]; // Accedemos al evento actual desde la lista de eventos
              // Analizamos la fecha original en un objeto DateTime
              var originalDateTime = DateTime.parse(event.startDate);

              // Formateamos la fecha en el formato deseado "dd/MM HH:mm"
              var formattedDate =
                  "${originalDateTime.day}/${originalDateTime.month.toString().padLeft(2, '0')} ${originalDateTime.hour.toString().padLeft(2, '0')}:${originalDateTime.minute.toString().padLeft(2, '0')}";

              return Container(
                decoration: BoxDecoration(
                  color: cardColors[index %
                      cardColors
                          .length], // Usamos colores de la lista de cardColors de manera circular
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        event.name, // Mostramos el nombre del evento
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                      SizedBox(
                          height:
                              5), // Espacio entre el nombre y la descripción
                      Text(
                        event.position, // Mostramos la descripción del evento
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(
                          height:
                              5), // Espacio entre el nombre y la descripción
                      Text(
                        formattedDate, // Mostramos la descripción del evento
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(
                          height:
                              10), // Espacio entre el nombre y la descripción
                      Text(
                        event
                            .description, // Mostramos la descripción del evento
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: 550, // Altura del swiper
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              initialPage: 0,
              viewportFraction:
                  0.8, // Tamaño de la tarjeta visible en la pantalla
            ),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 150, // Ajusta el ancho del botón 'Like'
                height: 55, // Ajusta la altura del botón 'Like'
                child: ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(Icons.favorite_border),
                  label: Text('Like'),
                ),
              ),
              SizedBox(
                  width:
                      40), // Ajusta la separación horizontal entre los botones
              SizedBox(
                width: 150, // Ajusta el ancho del botón 'Dislike'
                height: 55, // Ajusta la altura del botón 'Dislike'
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.disabled_by_default_outlined),
                  label: Text('Dislike'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
