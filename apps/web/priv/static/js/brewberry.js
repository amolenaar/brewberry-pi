"use strict";

function send(url, data) {
    var xmlhttp = new XMLHttpRequest();

    xmlhttp.open("POST", url, true);
    xmlhttp.setRequestHeader("Content-Type", "application/json");
    xmlhttp.send(JSON.stringify(data));
}

function Logger() {
    var self = riot.observable(this);

    function normalizeSample(sample) {
        sample.time = Date.parse(sample.time);
        sample.heater = sample.heater ? 1 : 0;
        return sample;
    }

    var eventSource;

    this.state = function () {
       return eventSource.readyState;
    };

    this.onlineCheck = function () {
        // EventSource watchdog
        // readyState: 0=connecting, 1=open, 2=closed
        if (!eventSource || eventSource.readyState === 2) {
            if (eventSource) { eventSource.close(); }

            eventSource = new EventSource("logger");

            eventSource.addEventListener("sample", function(event) {

                var sample = JSON.parse(event.data);
                if (sample) {
                    normalizeSample(sample);
                    self.trigger("sample", sample);
                }

            }, false);

            eventSource.addEventListener("samples", function(event) {

                var samples = JSON.parse(event.data);
                if (samples) {
                    for (var i in samples) normalizeSample(samples[i]);
                    self.trigger("samples", samples);
                }

            }, false);
        }
    };

    setInterval(this.onlineCheck, 1000);

    this.onSample = function (callback) {
        self.on("sample", callback);
    };

    this.onSampleOnce = function (callback) {
        self.one("sample", callback);
    };

    this.onlineCheck();
}

function Controls() {
    var self = this;

    function setHeater(power) {
        send("/controller", { "set": power });
    }

    this.turnOn = function () {
        setHeater("on");
    };

    this.turnOff = function () {
        setHeater("off");
    };

    this.setTemperature = function (t) {
        send("/temperature", { "set": t });
    };
}

// Presenter
window.onload = (function () {

    var logger = new Logger(),
        controls = new Controls();

    /* Chart */
    var chart = logChart(document.querySelector("#log-chart"));

    addSeries(chart, logger, {
        "name": "Heater",
        "type": "switch",
        "x": "time",
        "y": "heater",
        "color": "#DF5353" });
    addSeries(chart, logger, {
        "name": "Mash temperature",
        "type": "temperature",
        "x": "time",
        "y": "mash_temperature",
        "color": "#DDDF0D" });
    addSeries(chart, logger, {
        "name": "Temperature",
        "type": "temperature",
        "x": "time",
        "y": "temperature",
        "color": "#0000BF" });

    /* Controls */
    var temperatureDisplay = document.querySelector("#temperature"),
        turnOnOffButton = document.querySelector("#turn-on-off"),
        setTemperatureButton = document.querySelector("#set-temperature"),
        healthDisplay = document.querySelector("#health");

    logger.onSampleOnce(function (sample) {
        setTemperatureButton.value = sample.mash_temperature;
        turnOnOffButton.checked = (sample.mode !== "idle");
    });

    logger.onSample(function (sample) {
        temperatureDisplay.textContent = sample.temperature.toFixed(2);
        healthDisplay.classList.toggle("odd");
        healthDisplay.textContent = (new Date().toLocaleTimeString() + " / " + sample.mode);
    });

    turnOnOffButton.addEventListener("change", function () {
        if (this.checked) {
            controls.turnOn();
        } else {
            controls.turnOff();
        }
        // Check logger, re-initiate if needed.
        logger.onlineCheck();
        // turnOnButton.text("...");
    });

    setTemperatureButton.addEventListener("change", function (event) {
        var temperature = setTemperatureButton.value;
        if (temperature) {
            controls.setTemperature(parseInt(temperature));
        }
        return false;
    });
})();

// vim:sw=4:et:ai
