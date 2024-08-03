<?php 

class WeatherService {
    public function getCurrentTemperature() {
        return file_get_contents('http://api.weather.com/current');
    }
}