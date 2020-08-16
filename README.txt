Przed u�ytkowaniem projektu nale�y odpali� skrypt setup.m (za��czenie folder�w)
Folder data zawiera pliki z zapisanymi lub generowanymi na bie��co danymi:
    * data.mat - zawiera warto�ci parametr�w obiektu
    * DMC.mat - wyznaczane na pocz�tku symulacji parametry regulator�w predykcyjnych
    * steprespmodel.mat - wyznaczony model obiektu w postaci odpowiedzi skokowej
Folder plant zawiera funkcje wyznaczaj�ce przyrosty obiekt�w:
	* nieliniowego - plant.m
	* zlinearyzowanego - plant_lin.m
	Funkcji plant_lin mo�na u�ywa� r�wnie� do wyznaczenia stanu w kolejnel chwili obiektu dyskretnego,
	jako �e przyjmuje ona jako argumenty macierze stanu.
    * obiektu odprz�gaj�cego - decoupler.m
Folder functions zawiera przydatne funkcje:
	* control_delay.m - funkcja realizuj�ca op�nienie sygna�u steruj�cego na potrzeby symulacji 
		ci�g�ej realizowanej funkcj� ode45
	* linAB.m - funkcja wyznaczaj�ca macierze reprezentuj�ce model zlinearyzowany wok� zadanego punktu pracy
	* AB2GH.m - funkcja przekszta�caj�ca macierze r�wna� stanu modelu zlinearyzowanego do 
		do macierzy r�wna� stanu modelu dyskretnego zlinearyzowanego
		Wewn�trz tej funkcji mo�na zmieni� metod� dyskretyzacji zmieniaj�c argument funkcji c2d
		domy�lne ustawienie to 'tutsin'
    * aeye.m - funkcja dpowiadaj�ca funkcji eye tworz�ca macierz przeciwdiagonaln�
    * distortion.m - funkcja generuj�ca i zapisuj�ca przebiegi zak��ce�
    * matdiag.m - funkjca tworz�ca macierz diagonaln� z elementami diagonali postaci macierzy kwadratowych
    * output_delay.m - funkcja realizuj�ca op�nienie sygna�u wyj�ciowego
    * steering.m - funkcja czasu generuj�ca przebieg sterowania (warto�ci zadanych)
Folder scripts zawiera skrypty realizuj�ce symulacje i obrazuj�ce inne wyniki
	* static.m - przedstawia charakterystyk� statyczn� obiektu nieliniowego
	* obj_stepresp.m - symulacja odpowiedzi obiektu nieliniowego na 4 skoki sterowa�
		wektor step okre�la zakresy tych skok�w: pierwszy element zaresy skoku dop�ywu wody ciep�ej, drugi zimnej
		przyk�adowo step = [0.5; -0.25; 0; 0] spowoduje symulacje czterech przypadk�w:
			-skoku dop�ywu wody ciep�ej o -50% warto�ci w punkcie pracy i zimnej o +25%
			-skoku wody ciep�ej o -0.5*50% i zimnej o +0.5*25%
			-skoku wody ciep�ej o +0.5*50% i zimnej o -0.5*25%
			-skoku wody ciep�ej o +1*50% i zimnej o -1*25% 
	* obj_lin_stepresp.m - symulacja odpowiedzi obiektu zlinearyzowanego z analogicznie ustawianym wektorem step
	* lin_nonlin_stepresp.m - symulacja por�wnawcza odpowiedzi obiekty nieliniowego ze zlinearyzowanym, ustawiany wektor step
	* transmit.m - generacja transmitancji obiektu zlinerayzowanego z uwzgl�dnieniem op�nienia wej�� i wyj��
	  	wy�wietlenie transmitancji modelu ci�g�ego lub dyskretnego wymaga odkomentowania zaznaczonych linji kodu
	* obj_lin_disc_stepresp.m - symulacja odpowiedzi dyskretnego modelu zlinearyzowanego
		z wektorem step i ustawianym czasem dyskretyzacji Ts
	* lin_disc_stepresp.m - symulacja por�wnawcza zlinearyzowanego modelu ci�g�ego z zdyskretyzowanym
		z wektorem step i ustawianym czasem dyskretyzacji Ts
    * DMCparams.m - skrypt wyznaczaj�cy parametry regulator�w DMC na podstawie odpowiedzi skokowych oraz zadanych 
        parametr�w N, Nu, lambda i psi
    * REG.m - skrypt realizuj�cy regulacje obiektu wybranym regulatorem w odpowiedzi na szereg skok�w warto�ci zadanych
    * REG_cmp.m - skrypt realizuj�cy por�wnanie regulacji dwoma r�nymi regulatorami przy warto�ci docelowej
        zadawanej funkcj� steering
    * step_resp_model.m - skrypt wyznaczaj�cy model obiektu w postaci odpowiedzi skokowej
Folder controls zawiera realizacje r�nych regulator�w:
    * DMCa - regulator predykcyjny DMC analityczny
    * DMCn - regulator predykcyjny DMC numeryczny
    * PID - zwyk�y regulator PID
    * PID_decouple - regulator PID z odsprzeganiem