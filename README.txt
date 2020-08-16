Przed u¿ytkowaniem projektu nale¿y odpaliæ skrypt setup.m (za³¹czenie folderów)
Folder data zawiera pliki z zapisanymi lub generowanymi na bie¿¹co danymi:
    * data.mat - zawiera wartoœci parametrów obiektu
    * DMC.mat - wyznaczane na pocz¹tku symulacji parametry regulatorów predykcyjnych
    * steprespmodel.mat - wyznaczony model obiektu w postaci odpowiedzi skokowej
Folder plant zawiera funkcje wyznaczaj¹ce przyrosty obiektów:
	* nieliniowego - plant.m
	* zlinearyzowanego - plant_lin.m
	Funkcji plant_lin mo¿na u¿ywaæ równie¿ do wyznaczenia stanu w kolejnel chwili obiektu dyskretnego,
	jako ¿e przyjmuje ona jako argumenty macierze stanu.
    * obiektu odprzêgaj¹cego - decoupler.m
Folder functions zawiera przydatne funkcje:
	* control_delay.m - funkcja realizuj¹ca opó¿nienie sygna³u steruj¹cego na potrzeby symulacji 
		ci¹g³ej realizowanej funkcj¹ ode45
	* linAB.m - funkcja wyznaczaj¹ca macierze reprezentuj¹ce model zlinearyzowany wokó³ zadanego punktu pracy
	* AB2GH.m - funkcja przekszta³caj¹ca macierze równañ stanu modelu zlinearyzowanego do 
		do macierzy równañ stanu modelu dyskretnego zlinearyzowanego
		Wewn¹trz tej funkcji mo¿na zmieniæ metodê dyskretyzacji zmieniaj¹c argument funkcji c2d
		domyœlne ustawienie to 'tutsin'
    * aeye.m - funkcja dpowiadaj¹ca funkcji eye tworz¹ca macierz przeciwdiagonaln¹
    * distortion.m - funkcja generuj¹ca i zapisuj¹ca przebiegi zak³óceñ
    * matdiag.m - funkjca tworz¹ca macierz diagonaln¹ z elementami diagonali postaci macierzy kwadratowych
    * output_delay.m - funkcja realizuj¹ca opóŸnienie sygna³u wyjœciowego
    * steering.m - funkcja czasu generuj¹ca przebieg sterowania (wartoœci zadanych)
Folder scripts zawiera skrypty realizuj¹ce symulacje i obrazuj¹ce inne wyniki
	* static.m - przedstawia charakterystykê statyczn¹ obiektu nieliniowego
	* obj_stepresp.m - symulacja odpowiedzi obiektu nieliniowego na 4 skoki sterowañ
		wektor step okreœla zakresy tych skoków: pierwszy element zaresy skoku dop³ywu wody ciep³ej, drugi zimnej
		przyk³adowo step = [0.5; -0.25; 0; 0] spowoduje symulacje czterech przypadków:
			-skoku dop³ywu wody ciep³ej o -50% wartoœci w punkcie pracy i zimnej o +25%
			-skoku wody ciep³ej o -0.5*50% i zimnej o +0.5*25%
			-skoku wody ciep³ej o +0.5*50% i zimnej o -0.5*25%
			-skoku wody ciep³ej o +1*50% i zimnej o -1*25% 
	* obj_lin_stepresp.m - symulacja odpowiedzi obiektu zlinearyzowanego z analogicznie ustawianym wektorem step
	* lin_nonlin_stepresp.m - symulacja porównawcza odpowiedzi obiekty nieliniowego ze zlinearyzowanym, ustawiany wektor step
	* transmit.m - generacja transmitancji obiektu zlinerayzowanego z uwzglêdnieniem opóŸnienia wejœæ i wyjœæ
	  	wyœwietlenie transmitancji modelu ci¹g³ego lub dyskretnego wymaga odkomentowania zaznaczonych linji kodu
	* obj_lin_disc_stepresp.m - symulacja odpowiedzi dyskretnego modelu zlinearyzowanego
		z wektorem step i ustawianym czasem dyskretyzacji Ts
	* lin_disc_stepresp.m - symulacja porównawcza zlinearyzowanego modelu ci¹g³ego z zdyskretyzowanym
		z wektorem step i ustawianym czasem dyskretyzacji Ts
    * DMCparams.m - skrypt wyznaczaj¹cy parametry regulatorów DMC na podstawie odpowiedzi skokowych oraz zadanych 
        parametrów N, Nu, lambda i psi
    * REG.m - skrypt realizuj¹cy regulacje obiektu wybranym regulatorem w odpowiedzi na szereg skoków wartoœci zadanych
    * REG_cmp.m - skrypt realizuj¹cy porównanie regulacji dwoma ró¿nymi regulatorami przy wartoœci docelowej
        zadawanej funkcj¹ steering
    * step_resp_model.m - skrypt wyznaczaj¹cy model obiektu w postaci odpowiedzi skokowej
Folder controls zawiera realizacje ró¿nych regulatorów:
    * DMCa - regulator predykcyjny DMC analityczny
    * DMCn - regulator predykcyjny DMC numeryczny
    * PID - zwyk³y regulator PID
    * PID_decouple - regulator PID z odsprzeganiem