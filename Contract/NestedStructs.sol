//SPDX-License-Identifier: GPL - 3.0

pragma solidity ^0.8.21;

contract ClassTask1 {
    uint id;
    mapping(uint => ResidentVisa) residentCountry;

    enum Application {
        Pending,
        Processed,
        Accepted,
        Rejected,
        Canceled
    }

    struct ResidentVisa {
        string name;
        uint age;
        bool male;
        string occupation;
        Country _country;
        Application _application;
    }

    struct Country {
        string name;
        string continent;
        uint population;
        string capital;
        mapping(uint => State) residents;
    }

    struct State {
        string name;
        string capital;
        string governor;
        uint noOfLGA;
        uint population;
    }

    function applyResident(
        string memory _name,
        uint _age,
        bool _male,
        string memory _occupation,
        string memory _countryName,
        string memory _continent,
        uint _population,
        string memory _capital,
        State memory _state
    ) public {
        id = id + 1;
        ResidentVisa storage newResident = residentCountry[id];
        newResident.name = _name;
        newResident.age = _age;
        newResident.male = _male;
        newResident.occupation = _occupation;
        newResident._country.name = _countryName;
        newResident._country.continent = _continent;
        newResident._country.population = _population;
        newResident._country.capital = _capital;

        newResident._country.residents[id] = _state;
    }

    function retrieveInformation(
        uint _id
    ) external view returns (State memory residentState) {
        ResidentVisa storage getResident = residentCountry[id];
        residentState = getResident._country.residents[_id];
    }
}
