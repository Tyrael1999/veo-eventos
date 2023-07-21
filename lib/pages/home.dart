import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:veo_eventos/app_state.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    List<Color> cardColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
    ]; // Tu lista de colores para el swiper

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          CarouselSlider.builder(
            itemCount: cardColors.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              return Container(
                decoration: BoxDecoration(
                  color: cardColors[
                      index], // Usamos el color de la lista en función del índice
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Center(
                  child: Text(
                    'Tarjeta ${index + 1}',
                    style: TextStyle(fontSize: 24, color: Colors.white),
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
