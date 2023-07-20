import 'package:flutter/material.dart';
import 'package:veo_eventos/app_state.dart';
import 'package:provider/provider.dart';
import 'package:swipe_cards/swipe_cards.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();
    // Lista de datos estáticos para mostrar en las tarjetas
  final List<String> staticData = [
    'Dato 1',
    'Dato 2',
    'Dato 3',
    'Dato 4',
    'Dato 5',
  ];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          SwipeCards(
            data:  staticData, //appState.allPairs, // Reemplaza appState.allPairs con tu lista de datos que desees mostrar en las tarjetas.
            onSwipeCallback: (int index, SwipeDirection swipeDirection) {
              if (swipeDirection == SwipeDirection.left) {
                // Usuario deslizó la tarjeta hacia la izquierda
              } else if (swipeDirection == SwipeDirection.right) {
                // Usuario deslizó la tarjeta hacia la derecha
              }
            },
            itemBuilder: (BuildContext context, int index) {
              var pair = appState.allPairs[index];
              IconData icon;
              if (appState.favorites.contains(pair)) {
                icon = Icons.favorite;
              } else {
                icon = Icons.favorite_border;
              }

              return Card(
                child: Column(
                  children: [
                    // Aquí puedes mostrar el contenido de tu tarjeta.
                    // Por ejemplo, si 'pair' es un objeto, muestra sus propiedades.
                    // Si 'pair' es un String, simplemente muestra el String.
                    Text(pair.toString()),

                    // Agrega el botón de "Like" a cada tarjeta.
                    ElevatedButton.icon(
                      onPressed: () {
                        appState.toggleFavorite();
                      },
                      icon: Icon(icon),
                      label: Text('Like'),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              appState.getNext();
            },
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}
