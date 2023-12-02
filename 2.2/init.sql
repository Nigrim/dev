-- Таблица readers (читатели)
CREATE TABLE IF NOT EXISTS public.readers (
    number_of_reader_ticket uuid PRIMARY KEY, -- Уникальный номер читательского билета в формате UUID.
    reader_fio VARCHAR(255) NOT NULL,         -- ФИО читателя в виде строки с максимальной длиной 255 символов.
    reader_address VARCHAR(255) NOT NULL,     -- Адрес читателя в виде строки с максимальной длиной 255 символов.
    reader_phone_number INTEGER NOT NULL       -- Номер телефона читателя в целочисленном формате.
);

-- Таблица lending_of_books (аренда книг)
CREATE TABLE IF NOT EXISTS public.lending_of_books (
    lending_of_book_id uuid PRIMARY KEY,    -- Уникальный идентификатор операции выдачи книги в формате UUID.
    lending_date DATE NOT NULL,              -- Дата выдачи книги в формате DATE.
    return_date DATE NOT NULL,               -- Дата возврата книги в формате DATE.
    number_of_reader_ticket uuid,            -- Внешний ключ, связывающийся с readers.number_of_reader_ticket.
    copies_of_books_id uuid,                 -- Внешний ключ, связывающийся с copies_of_books.copies_of_books_id.
    FOREIGN KEY (number_of_reader_ticket) REFERENCES readers (number_of_reader_ticket) ON DELETE CASCADE,
    FOREIGN KEY (copies_of_books_id) REFERENCES copies_of_books (copies_of_books_id) ON DELETE SET NULL
);

-- Таблица authors (авторы)
CREATE TABLE IF NOT EXISTS public.authors (
    author_id uuid PRIMARY KEY,         -- Уникальный идентификатор автора в формате UUID.
    author_fio VARCHAR(255) NOT NULL    -- ФИО автора (Фамилия, Имя, Отчество) в виде строки с максимальной длиной 255 символов.
);

-- Таблица books (книги)
CREATE TABLE IF NOT EXISTS public.books (
    book_cipher uuid PRIMARY KEY,            -- Уникальный идентификатор книги в формате UUID.
    book_name VARCHAR(255) NOT NULL,         -- Название книги в виде строки с максимальной длиной 255 символов.
    year_of_publishing_book DATE NOT NULL,   -- Год публикации книги в формате DATE.
    book_size INTEGER NOT NULL,               -- Размер книги в целочисленном формате.
    book_prise REAL NOT NULL,                 -- Стоимость книги в вещественном формате.
    count_copies_of_book INTEGER NOT NULL,    -- Количество копий книги в целочисленном формате.
    author_id uuid,                          -- Внешний ключ, связывающийся с authors.author_id.
    publishing_house_id uuid,                 -- Внешний ключ, связывающийся с publishing_houses.publishing_house_id.
    FOREIGN KEY (author_id) REFERENCES authors (author_id) ON DELETE SET NULL,
    FOREIGN KEY (publishing_house_id) REFERENCES publishing_houses (publishing_house_id) ON DELETE SET NULL
);

-- Таблица publishing_houses (издательство)
CREATE TABLE IF NOT EXISTS public.publishing_houses (
    publishing_house_id uuid PRIMARY KEY,       -- Уникальный идентификатор издательства в формате UUID.
    publishing_house_name VARCHAR(255) NOT NULL, -- Название издательства в виде строки с максимальной длиной 255 символов.
    city_code INTEGER,                           -- Внешний ключ, связывающийся с cities.city_code.
    FOREIGN KEY (city_code) REFERENCES cities (city_code) ON DELETE SET NULL
);

-- Таблица authors_books (книги авторов)
CREATE TABLE IF NOT EXISTS public.authors_books (
    book_author_id uuid PRIMARY KEY,    -- Уникальный идентификатор связи между книгой и автором в формате UUID.
    book_cipher uuid,                    -- Внешний ключ, связывающийся с books.book_cipher.
    author_id uuid,                      -- Внешний ключ, связывающийся с authors.author_id.
    FOREIGN KEY (book_cipher) REFERENCES books (book_cipher) ON DELETE SET NULL,
    FOREIGN KEY (author_id) REFERENCES authors (author_id) ON DELETE SET NULL
);
