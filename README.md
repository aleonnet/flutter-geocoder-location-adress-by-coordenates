# Localizador de Endereços com GoogleMaps e Geocoder
###### geocoder_api_getting_adress_by_googlemaps_coordinates
--------

(POC) ou Conceito de projeto simples feito em [Flutter](https://flutter.dev) para localizar endereços usando coordenadas de latitude e longitude. Para visualizar as dependencias usadas veja o [pubspec.yaml](/pubspec.yaml).

## Começando a usar

#### Primeiro é necessário uma [API-KEY](https://developers.google.com/maps/documentation/android-sdk/get-api-key) do Google maps

- Para usar a api do google maps é necessária um [API-KEY](https://developers.google.com/maps/documentation/android-sdk/get-api-key) fornecida pela google em sua conta de desenvolvedor sdk android.

#### Tendo criado sua api key do google maps

- Cole a chave fornecida em seu projeto no lugar indicado abaixo
dentro do arquivo .xml que fica localizado em android/app/src/main/AndroidManifest.xml

```bash

|_ android
  |_ app
    |_ src
      |_ main
        |_ AndroidManifest.xml
```
```xml
<manifest ...>
   <aplication ...>
        <meta-data 
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR-API-KEY-VALUE-HERE"/>
   <!--Fica dentro da tag aplication-->
   </aplication>
</manifest>
```
## Funcionamento da aplicação

|   Selecionando uma coordenada no mapa   |  Após selecionar um lugar, é possível observar os possiveis endereços para a coordenada  |    Permissão é necessária para usar a própria localização do dispositivo    |
|:---:|:---:|:---:|
| <img src="/assets/examples/images/gif1.gif" width="80%">  | <img src="/assets/examples/images/gif2.gif" width="80%">     | <img src="/assets/examples/images/gif3.gif" width="80%">    |
