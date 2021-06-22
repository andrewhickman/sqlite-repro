using System;
using System.Data.SQLite;

namespace SqliteRepro
{
    class Program
    {
        static void Main(string[] args)
        {
            using var connection = new SQLiteConnection($"Data Source=data.sqlite;Version=3;");
            Console.WriteLine("Hello World!");
        }
    }
}
