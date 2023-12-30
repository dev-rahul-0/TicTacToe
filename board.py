import tkinter as tk
from tkinter import messagebox

class SmallBoard:
    def __init__(self):
        self.board = [[" " for _ in range(3)] for _ in range(3)]
        self.winner = None

    def print_small_row(self, row, end="\n"):
        print(" | ".join(self.board[row]), end=end)

    def check_winner(self):
        # Check rows and columns
        for i in range(3):
            if self.board[i][0] == self.board[i][1] == self.board[i][2] != " ":
                return self.board[i][0]
            if self.board[0][i] == self.board[1][i] == self.board[2][i] != " ":
                return self.board[0][i]

        # Check diagonals
        if self.board[0][0] == self.board[1][1] == self.board[2][2] != " ":
            return self.board[0][0]
        if self.board[0][2] == self.board[1][1] == self.board[2][0] != " ":
            return self.board[2][0]

        return None

    def make_move(self, row, col, player):
        if self.board[row][col] == " ":
            self.board[row][col] = player
            self.winner = self.check_winner()
            return True
        return False

class MainBoard:
    def __init__(self):
        self.boards = [[SmallBoard() for _ in range(3)] for _ in range(3)]
        self.global_winner = None

    def print_board(self):
        for row in range(3):
            for sub_row in range(3):
                for col in range(3):
                    self.boards[row][col].print_small_row(sub_row, end=" || ")
                print()
            if row < 2:
                print("=" * 40)

    def check_global_winner(self):
        # Check rows and columns
        for i in range(3):
            if (self.boards[i][0].winner == self.boards[i][1].winner == self.boards[i][2].winner != None or
                self.boards[0][i].winner == self.boards[1][i].winner == self.boards[2][i].winner != None):
                self.global_winner = self.boards[i][0].winner
                return

        # Check diagonals
        if (self.boards[0][0].winner == self.boards[1][1].winner == self.boards[2][2].winner != None or
            self.boards[0][2].winner == self.boards[1][1].winner == self.boards[2][0].winner != None):
            self.global_winner = self.boards[1][1].winner

    def make_move(self, main_row, main_col, sub_row, sub_col, player):
        if self.boards[main_row][main_col].make_move(sub_row, sub_col, player):
            self.check_global_winner()
            return True
        return False
    


    def are_all_boards_empty(self):
        for small_board in (sb for row in self.boards for sb in row):
            if any(cell != " " for row in small_board.board for cell in row):
                return False
        return True


    def get_playable_boards(self, last_move):
        if self.are_all_boards_empty():
            return [(i, j) for i in range(3) for j in range(3)]

        last_move_row, last_move_col = last_move
        if self.boards[last_move_row][last_move_col].winner is None:
            return [(last_move_row, last_move_col)]
        
        # If the targeted board is already won, all non-won boards are playable
        return [(i, j) for i in range(3) for j in range(3) 
                if self.boards[i][j].winner is None]

def get_player_input(player, playable_boards):
    # Example input function, adapt as necessary
    print(f"Player {player}, choose a board and position to play.")
    print(f"Playable boards: {playable_boards}")
    main_row = int(input("Enter main board row (0-2): "))
    main_col = int(input("Enter main board column (0-2): "))
    sub_row = int(input("Enter sub-board row (0-2): "))
    sub_col = int(input("Enter sub-board column (0-2): "))
    return main_row, main_col, sub_row, sub_col

def get_subboard_input(player, sub_board):
    print(f"Player {player}, choose a position to play on the sub-board.")
    sub_row = int(input("Enter sub-board row (0-2): "))
    sub_col = int(input("Enter sub-board column (0-2): "))
    return sub_row, sub_col

def main():
    main_board = MainBoard()
    current_player = "X"
    last_move = (0, 0)  # Initial last move can be any value

    while main_board.global_winner is None:
        main_board.print_board()
        playable_boards = main_board.get_playable_boards(last_move)

        move_made = False
        while not move_made:
            if len(playable_boards) == 1:
                # Directly choose position on the sub-board
                main_row, main_col = playable_boards[0]
                print(f"Playable board is ({main_row}, {main_col}).")
                sub_row, sub_col = get_subboard_input(current_player, main_board.boards[main_row][main_col])
            else:
                # Choose both main and sub-board positions
                main_row, main_col, sub_row, sub_col = get_player_input(current_player, playable_boards)

            if main_board.boards[main_row][main_col].board[sub_row][sub_col] == " ":
                main_board.make_move(main_row, main_col, sub_row, sub_col, current_player)
                last_move = (sub_row, sub_col)
                move_made = True
            else:
                print("Invalid move. Please choose a different position.")


        # Check for winner and switch player
        if main_board.global_winner:
            main_board.print_board()
            print(f"Player {main_board.global_winner} wins!")
            break

        current_player = "O" if current_player == "X" else "X"



class SmallBoardUI(tk.Frame):
    def __init__(self, master, main_row, main_col, click_callback):
        super().__init__(master, borderwidth=1, relief="solid")
        self.main_row = main_row
        self.main_col = main_col
        self.click_callback = click_callback
        self.buttons = [[tk.Button(self, text=" ", font=("Arial", 24), height=2, width=5, 
                        command=lambda row=row, col=col: self.on_click(row, col)) 
                        for col in range(3)] for row in range(3)]
        for row in range(3):
            for col in range(3):
                self.buttons[row][col].grid(row=row, column=col)

    def on_click(self, row, col):
        self.click_callback(self.main_row, self.main_col, row, col)

    def update_cell(self, row, col, player):
        self.buttons[row][col].config(text=player, state="disabled")

class MainBoardUI(tk.Tk):
    def __init__(self, main_board):
        super().__init__()
        self.main_board = main_board
        self.title("Tic Tac Toe")
        self.small_boards = [[SmallBoardUI(self, row, col, self.on_click) for col in range(3)] for row in range(3)]
        for row in range(3):
            for col in range(3):
                self.small_boards[row][col].grid(row=row, column=col, padx=2, pady=2)

        self.current_player_label = tk.Label(self, text="Current Player: X", font=("Arial", 16))
        self.current_player_label.grid(row=3, column=0, columnspan=3)

    def on_click(self, main_row, main_col, sub_row, sub_col):
        if self.main_board.make_move(main_row, main_col, sub_row, sub_col, self.main_board.current_player):
            self.small_boards[main_row][main_col].update_cell(sub_row, sub_col, self.main_board.current_player)
            if self.main_board.global_winner:
                messagebox.showinfo("Game Over", f"Player {self.main_board.global_winner} wins!")
                self.quit()
            else:
                self.main_board.switch_player()
                self.current_player_label.config(text=f"Current Player: {self.main_board.current_player}")

class MainBoard(MainBoard):  # Inherits from your existing MainBoard
    def __init__(self):
        super().__init__()
        self.current_player = "X"

    def switch_player(self):
        self.current_player = "O" if self.current_player == "X" else "X"

def main():
    main_board = MainBoard()
    app = MainBoardUI(main_board)
    app.mainloop()

if __name__ == "__main__":
    main()
