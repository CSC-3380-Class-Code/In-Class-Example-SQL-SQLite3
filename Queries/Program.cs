namespace Query;

using System;
using System.Data;
using Microsoft.Data.Sqlite;

public static class Queries{

	public static void Main(){
		SqliteConnection connection = CreateConnection();

		//AllItems(connection);
      //TennesseeAddresses(connection);
      TopShipping(connection);

		connection.Close();
	}

	static SqliteConnection CreateConnection(){
         SqliteConnection sqlite_conn;
         // Create a new database connection:
         sqlite_conn = new SqliteConnection("Data Source=../Database/store.db");
         // Open the connection:
         try
         {
            sqlite_conn.Open();
         }
         catch (Exception)
         {
			Console.WriteLine("Couldn't Connect to database");
         }
         return sqlite_conn;
      }

	  static void PrintQueryResult(SqliteDataReader sqlite_datareader){
		while (sqlite_datareader.Read()){
			object[] row = new object[sqlite_datareader.FieldCount];
         sqlite_datareader.GetValues(row);
			foreach(object val in row){
				Console.Write($" {val} |");
			}
			Console.WriteLine();
         }
	  }

	  static void RunAndPrintQuery(SqliteConnection conn, string queryString)
      {
         SqliteDataReader sqlite_datareader;
         SqliteCommand sqlite_cmd;
         sqlite_cmd = conn.CreateCommand();

         sqlite_cmd.CommandText = queryString;

         sqlite_datareader = sqlite_cmd.ExecuteReader();
		   PrintQueryResult(sqlite_datareader);
      }

      static void AllItems(SqliteConnection conn){
         string query = "Select * From Item";

         RunAndPrintQuery(conn, query);
      }

      static void TennesseeAddresses(SqliteConnection conn){
         string state = "Louisiana";
         string query = $"Select Address, City, State From Address Where State = '{state}'";

         RunAndPrintQuery(conn, query);
      }

      static void TopShipping(SqliteConnection conn){
         string query = @"Select Address.City, Address.State, Sum(CartItem.Quantity)
                        From Address
                        Join CartItem
                        On Address.Address_ID = CartItem.Address_ID
                        Group by Address.City
                        Order by sum(CartItem.Quantity) DESC
                        Limit 5;";

         RunAndPrintQuery(conn, query);
      }
}
