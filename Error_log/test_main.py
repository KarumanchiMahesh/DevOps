import unittest
import main

class test_main(unittest.TestCase):
    def test_final_error(self):
        len, logs = main.final_error('[123]',['2019-4-1 13:32:40 [190] User3 logs in', '2019-4-1 13:33:45 [123] User1 logs in', '2019-4-1 13:33:45 [123] User1 goes to search page', '2019-4-1 13:33:46 [123] User1 types in search text', '2019-4-1 13:33:48 [256] User2 logs in', '2019-4-1 13:33:49 [190] User3 runs some job', '2019-4-1 13:33:50 [123] User1 clicks search button', '2019-4-1 13:33:53 [256] User2 does something', '2019-4-1 13:33:54 [123] ERROR: Some exception occured', '2019-4-1 13:33:56 [256] User2 logs off', '2019-4-1 13:33:57 [190] ERROR: Invalid input'])
        self.assertEqual(len, 5)
        self.assertEqual(logs,['2019-4-1 13:33:45 [123] User1 goes to search page', '2019-4-1 13:33:46 [123] User1 types in search text', '2019-4-1 13:33:50 [123] User1 clicks search button', '2019-4-1 13:33:54 [123] ERROR: Some exception occured -----'])
        self.assertNotEqual(len, 3)
        self.assertNotEqual(logs,['2019-4-1 13:33:46 [123] User1 types in search text', '2019-4-1 13:33:50 [123] User1 clicks search button', '2019-4-1 13:33:54 [123] ERROR: Some exception occured -----'])

    def test_finderror(self):
        id = main.finderror('2019-4-1 13:33:45 [123] User1 goes to search page')
        self.assertEqual(id,'[123]')
        #self.assertEqual(line,'2019-4-1 13:33:45 [123] User1 goes to search page')
        self.assertNotEqual(id,'[111]')
        #self.assertNotEqual(line,'2019-4-1 13:33:45 [111] User1 goes to search page')

if __name__ == '__main__':
    unittest.main()