#define _CRT_SECURE_NO_WARNINGS

#include <iostream>
using namespace std;
#include <fstream>
#include <string>
#include <bits/stdc++.h> 
#include <sstream> 
#include <cmath>
#include <time.h>

string idd;

class History {
public:
	int usage;
	int total;
	int type;
};

History h[100];

extern "C" {

	// EXTERNAL METHODS
	void START();
	void ACCOUNT();
	int TEST2(int,int);

	// LOCAL METHODS
	class History;
	int convertDigit(char* usage);
	void receipt(int usage,int total,int type);
	void history(int usage, int total, int type);
	void authentication(char* id, char* password);
	void registerAcc(char* id, char* password);
	void checkHistory();
	void panel();
	void printRecord(int x);
}

int main()
{
	cout << "\n                    .$$$$$$P";
	cout << "\n                   z$$$$$$P";
	cout << "\n                 d$$$$$$''";
	cout << "\n               .d$$$$$$'";
	cout << "\n             .$$$$$$$'";
	cout << "\n            z$$$$$$$beeeeee'";
	cout << "\n           d$$$$$$$$$$$$$*";
	cout << "\n           ^'''''''$$$$$'";
	cout << "\n                   d$$$* ";
	cout << "\n                  d$$$''";
	cout << "\n                 d$$*";
	cout << "\n                d$P'";
	cout << "\n               .$$'";
	cout << "\n              .$P'";
	cout << "\n             .$'";
	cout << "\n            .P'";
	cout << "\n           .         (V) (V) (V)";
	cout << "\n          /           =   =   =";
	cout << "\n";

	ACCOUNT();

	system("pause");
}

void authentication(char* id, char* password) {

	// open file
	std::ifstream file;
	std::string fid, fpassword;

	string output;
	string login = "false";

	idd = id;

	string pass = password;
	string name = "account\\" + idd + ".txt";

	file.open(name, ios::in | ios::binary);
	if (!file)
	{
		cout << "\nThere is No Account with This ID Name ! \n\n";
		ACCOUNT();
	}
	else
	{

		while (file) {

			std::getline(file, fpassword); // use line end as delimiter (read text)

			if ((pass.compare(fpassword) != 0)) {

				login = "false";
			}
			else
			{
				login = "true";
				
			}

		}

		if (login == "false")
		{
			cout << "\nInvalid Login ! Please Try Again !!!\n\n";
			ACCOUNT();
		}
		else {
			cout <<"\n"+ idd + " Login Suceesfully !! \n\n";
			login = "true";

			panel();

		}

		
	}

}

void registerAcc(char* id, char* password) {

	// open file
	std::ifstream file;

	idd = id;
	string pass = password;
	string name = "account\\" + idd + ".txt";

	file.open(name, ios::in | ios::binary);
	if (file)
	{
		cout << "Account with This ID Already Exist, Please Login !! \n\n";
		ACCOUNT();
	}
	else
	{
		// Create and open a text file
		ofstream file2("account\\" + idd + ".txt");

		// Write to the file
		file2 << pass;

		// Close the file
		file2.close();


		// Create and open a text file
		ofstream file3("history\\" + idd + ".txt");

		// Close the file
		file3.close();

		cout << "Account Successfully Registered !! \n\n";
		ACCOUNT();

	}

}

void receipt(int usage,int total,int type)
{

	time_t     now = time(0); //get the current time
	struct tm  tstruct;
	char       time[80];
	tstruct = *localtime(&now);

	strftime(time, sizeof(time), "%Y-%m-%d_%OH-%M-%S", &tstruct);  //display string time and set the format of time

	string name = "Receipt\\" + idd + "_" + time + ".txt";

	ofstream file2("Receipt\\" + idd +"_"+ time + ".txt", fstream::app);


	std::string s_usage = std::to_string(usage);
	std::string s_total = std::to_string(total);

	float total_amount = total * 1.1 / 10000;

	total_amount = ceil(total_amount * 100); //round up the decimal point 
	total_amount = total_amount / 100;

	float tax = total * 0.1 /10000;
	float Ttotal = total * 1.0 / 10000.0; 

	string etype = "";

	//check the electricity type
	if (type == 1)
	{
		etype = "RESIDENTIAL";
	}
	else {
		etype = "COMMERCIAL";
	}

	file2 << "==========================\n";
	file2 << "ELECTRICITY BILL'S RECEIPT\n";
	file2 << "==========================\n";
	file2 << "ELECTIRICTY TYPE :" << etype;
	file2 << "\nUSAGE            :" <<usage;
	file2 << "\nSUB TOTAL        :RM" <<Ttotal;
	file2 << "\nTAX (10%)        :RM" <<tax ;
	file2 << "\n-------------------------";
	file2 << "\nTOTAL            :RM" << total_amount;

	// Close the file
	file2.close();

	cout << "Receipt Successfully Generated !!!\n\n";


}


void history(int usage, int total, int type)
{
	ofstream file2("history\\" + idd + ".txt", fstream::app);

	//convert int to string
	std::string s_usage = std::to_string(usage);
	std::string s_total = std::to_string(total);
	std::string s_type = std::to_string(type);

	file2 << s_usage + ";" + s_total + ";" + s_type + ";" << "\n" ;

	file2.close();

}

void checkHistory()
{
	ifstream file;

	int option;
	string history;

	bool blank = true;

	int x = 0;
	string name = "history\\"+idd+".txt";

	file.open(name, ios::in | ios::binary);
	if (!file)
	{
		cout << "\nThere is No History with This ID Name ! \n\n";
		ACCOUNT();
	}
	else
	{

		while (file) {


			string fusage;
			string ftotal;
			string ftype;

			std::getline(file, fusage, ';'); // use ; as delimiter

			std::getline(file, ftotal, ';'); // use ; as delimiter

			std::getline(file, ftype, ';'); 


			//covert string to int 
			stringstream usage(fusage);

			int u = 0;
			usage >> u;

			if (u >= 1)
			{
				blank = false;
			}

			//covert string to int 
			stringstream total(ftotal);
			int t = 0;
			total >> t;

			//covert string to int 
			stringstream type(ftype);
			int ty = 0;
			type >> ty;

			h[x].usage = u;
			h[x].total = t;
			h[x].type  = ty;

			x++;
		}

		cout << "====================\n";
		cout << "       HISTORY\n";
		cout << "====================\n";

		int i;

		if (blank == false)
		{
			for (i = 0; i < x; i++)
			{
				if (h[i].usage != 0)
				{
					string etype = "";

					if (h[i].type == 1)
					{
						etype = "RESIDENTIAL";
					}
					else {
						etype = "COMMERCIAL";
					}

					float total_amount = h[i].total * 1.1 / 10000;

					total_amount = ceil(total_amount * 100);
					total_amount = total_amount / 100;

					float tax = h[i].total * 0.1 / 10000;
					float total = h[i].total * 1.0 / 10000;



					cout << "==============================\n";
					cout << i + 1 << ". History\n";
					cout << "------------------------------\n";
					cout << "ELECTRICITY TYPE   :" << etype;
					cout << "\nUSAGE              :" << h[i].usage;
					cout << "\nSUB TOTAL          :RM" << total;
					cout << "\nTAX (10%)          :RM" << tax;
					cout << "\n------------------------------";
					cout << "\nTOTAL AMOUNT       :RM" << total_amount;
					cout << "\n=============================\n";
				}
			}

			printRecord(x);
	        

			cout << "\n";


		}
		else {
		
			cout << "Don't Have Any Record";
			cout << "\n====================\n\n";
		}

	}

	panel();

}


void panel() {

	string option;
	cout << "==================\n";
	cout << "   Member Panel \n";
	cout << "==================\n";
	cout << "1. Calculate Bill \n";
	cout << "2. Check History \n";
	cout << "3. Logout \n";
	cout << "------------------\n";
	cout << "Select Your Choice:";
	cin >> option;

	if (option == "1")
	{
		START();
	}
	else if (option == "2")
	{
		checkHistory();
	}
	else if (option == "3")
	{
		cout << "\n";
		cout << "Logout Successfully !!! \n\n";
		ACCOUNT();
	}
	else {

		cout << "Invalid Entry ! Try Again !! \n";

		panel();

	}

}

int convertDigit(char* usage) {

	//convert string to int
	stringstream u(usage);

	int digit = 0;

	u >> digit; 

	return digit;

}

void printRecord(int x)
{
	string option1;

	do {

		cout << "1.Print Receipt    :\n";
		cout << "2.Exit             :\n";
		cout << "------------------------------\n";
		cout << "Select Your Choice :";

		cin >> option1;

		cout << "\n";

		if (option1 == "1")
		{
			string option;

			cout << "Which Record ? :";

			cin >> option;

			stringstream convert(option);
			int option2 = 0;
			convert >> option2;


			if (option2 < x && option2 >= 1)
			{
				option2 = option2 - 1;
				cout << "\n";
				receipt(h[option2].usage, h[option2].total, h[option2].type);
			}
			else {

				cout << "\n";
				cout << "Invalid Entry !! Select Within the Range Only !! \n";
				cout << "\n";
				printRecord(x);
			}


		}
		else if (option1 == "2") {

			cout << "\n";
			panel();

		}
		else {

			cout << "Invalid Entry !! Select 1 or 2 Only !! \n";
			cout << "\n";

		}


	} while (option1 != "1" || option1 != "2");


}
