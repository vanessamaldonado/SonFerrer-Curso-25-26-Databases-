# **1. Non-relational databases and DBMS**

Traditionally, relational databases have been the standard for most companies and applications. This model, ideal for structured data and transactions requiring high integrity, has proven to be robust and efficient for decades. However, the explosion of large-scale data—known as *Big Data*—the need to manage unstructured or semi-structured information, and the demand for highly scalable and high-performance systems have revealed certain limitations of the relational model.

It is in this context that **NoSQL databases** (an acronym for Not only SQL) emerge. These databases represent a paradigm shift, moving away from the model of tables, primary keys, and foreign keys to offer more flexible alternatives adapted to new needs.

While relational databases excel in consistency and the elimination of data redundancy, NoSQL databases focus on **availability**, **horizontal scalability**, and **schema flexibility**.

This section will explore non-relational databases and database management systems (DBMS), analyzing their main data models, fundamental characteristics, advantages over the relational model, and their most common use cases. Once contextualized, we will focus on **MongoDB**, the most popular non-relational DBMS today.


> NoSQL
>
>The term NoSQL does not refer to a single data model, but rather encompasses a broad category of models and their respective database management systems (DBMS) that move away from the traditional relational model to offer alternatives.


## **1.1 Non-relational databases**

A non-relational database, also known as **NoSQL**, meaning “not only SQL,” is a data management system that does not use the tabular model of rows and columns typical of relational databases. These databases, which are optimized for different types of data, have become popular due to their flexibility, scalability, and high performance when handling large volumes of semi-structured or unstructured data.

### Main characteristics

Non-relational databases are distinguished by the following characteristics:

- **Flexible schema**: Unlike relational databases that require a predefined schema, NoSQL databases allow data to be stored in a free format or with a dynamic schema. This facilitates rapid application development and adaptation to changing needs.

- **Horizontal scalability**: These databases are designed to grow by adding more low-cost servers (horizontal scalability) instead of upgrading a single powerful server (vertical scalability). This capability makes them ideal for applications with large volumes of data and high traffic.

- **Distributed design**: Many NoSQL databases are distributed by default, eliminating a single point of failure and increasing system availability.

- **Non-compliance with ACID**: While relational databases follow ACID properties (Atomicity, Consistency, Isolation, and Durability) to ensure transaction integrity, many NoSQL databases prioritize availability and partition tolerance over immediate consistency, following the BASE principle (Basically Available).

### Types of non-relational databases

There are several types of NoSQL databases, each optimized for a specific data model and use case. The most relevant are:

- **Key-value**: Data is stored as a collection of key-value pairs. They are very simple and fast, ideal for caching systems or shopping lists.

- **Document-oriented**: They store data in flexible documents (for example, in JSON or XML format). They are useful for content management or user profiles, as they allow related data to be stored in a single document.

- **Wide-column**: They organize data in columns instead of rows. This model is efficient for analytical queries on large volumes of data, such as in Big Data.

- **Graph**: They are designed to store entities (nodes) and their relationships (edges). They are perfect for social network applications, recommendation systems, or fraud detection.

### Advantages and disadvantages

Their advantages are as follows:

  - **Performance**: They are very fast for specific operations, as they are optimized for particular data models.
  - **Flexibility**: Their dynamic schema allows faster and more flexible development.  
  - **Scalability**: Scaling horizontally is easier and more cost-effective.

Their disadvantages are as follows:

- **No standard exists**: Each NoSQL database has its own query language and API, making migration between systems difficult.
- **Lower consistency**: Prioritizing availability may result in eventual consistency instead of immediate consistency.
- **Lack of standardized support**: Many NoSQL databases are open source and do not always have the same level of support as commercial relational databases.

## **1.2 Non-relational DBMS**

**Non-relational Database Management Systems (DBMS)** move away from the traditional model discussed in previous topics to offer more flexible and scalable alternatives. These systems are generally known as NoSQL.

> The term NoSQL encompasses a wide range of these systems, each with a different data model, adapted to the needs of modern applications.

**MongoDB** is a very popular non-relational DBMS; in fact, it is one of the most widely used today. Throughout this topic, we will explore the main alternatives among **NoSQL** systems in general and, finally, focus on **MongoDB**.

### Main types of non-relational databases

Below are the main types of non-relational databases, each designed to meet specific needs.

**Key-Value Databases**. They are the simplest type of NoSQL database:

  - Characteristics: They store data as key-value pairs. The key is a unique identifier and the value can be any type of data (string, object, etc.). They are extremely efficient for fast read and write operations.
  - Use cases: Ideal for caching systems, user session management, and profile data storage.
  - Example: Redis.

**Wide-Column Databases**. This model organizes data in columns instead of rows:

  - Characteristics: They optimize operations on large volumes of data. Each row can have a different number of columns, allowing great flexibility. They are very efficient for massive data analysis (Big Data) and for queries that only require specific columns.
  - Use cases: Massive data analysis, time-series databases, and applications with large volumes of data.
  - Example: Apache Cassandra.

**Graph Databases**. They are based on graph theory, storing data as nodes (entities) and edges (relationships between entities):

  - Characteristics: They are designed to manage and query highly interconnected data. Traversing relationships is extremely fast.
  - Use cases: Social networks (friend connections), recommendation systems, and fraud detection.
  - Example: Neo4j.

**Document-Oriented Databases**. They store data in documents organized into collections:

  - Characteristics: Documents are flexible, semi-structured, and self-descriptive, using formats such as JSON or BSON. They do not require a rigid schema, allowing documents within the same collection to have different structures. They offer more complex queries than key-value databases.
  - Use cases: Ideal for product catalogs, content management systems, and user profiles, as they group related data into a single document.
  - Example: MongoDB.

### MongoDB, market leadership

**MongoDB** leads the non-relational database market thanks to its **flexibility and scalability**, features that make it ideal for modern web applications.

> MongoDB’s data model, based on JSON documents, is very intuitive for developers, as it matches the way many applications are built.

**Schema Flexibility**: Relational DBMS require a rigid schema, where each row in a table must follow a predefined structure. If a new field needs to be added, the schema of the entire table must be modified, which can be costly and complex, especially in large databases.

**MongoDB**, on the other hand, stores data in JSON documents that can have different structures within the same collection. This is ideal for:

  - Agile applications and startups: It allows rapid evolution of the data model without complex migrations.
  - Content management and catalogs: A product or item can have unique attributes without affecting others.
  - IoT data: Sensors can send data with different structures without schema issues.

**Horizontal Scalability**: Relational DBMS primarily scale vertically, meaning by increasing server power (CPU, RAM, etc.). This process is expensive and has a physical limit. MongoDB is designed to scale horizontally through sharding. This involves distributing data across multiple servers (clusters), enabling nearly unlimited growth at a lower cost. This capability is essential for:

  - Big Data: Managing large volumes of data that do not fit on a single server.
  - High web traffic: Distributing query load across multiple servers to improve performance.

**Document-Based Data Model**. In a relational DBMS, data for a complex object (such as a user profile) is fragmented across multiple tables (profile, addresses, purchase history, etc.) and connected through foreign keys. To retrieve all the information, complex joins are required, which can be slow. MongoDB stores all related data of an object in a single document. For example, the user profile and contact information are stored together. This:

  - Simplifies queries: All user information can be retrieved with a single read.
  - Improves performance: The need for multiple joins is eliminated.

>In summary, while a relational DBMS is perfect for structured data requiring strict referential integrity, MongoDB excels in environments where speed, flexibility, and scalability are priorities.

**MongoDB** becomes the preferred option for companies in certain areas compared to relational DBMS, mainly due to its flexibility, scalability, and data model, such as the following:

- **Applications with Variable Data**. MongoDB is ideal for applications where the data structure is not fixed or may change over time. This is the case for startup projects or agile applications where the data model evolves rapidly. Its schema-less nature eliminates the need for complex and costly migrations. This is a very important market niche, as many web and mobile projects require this flexibility.

- **Content Management and Catalogs**. Content management systems (CMS) and product catalogs in e-commerce platforms fit perfectly with MongoDB. A product can have a wide variety of attributes (colors, sizes, material, etc.) that may not apply to all products. MongoDB allows each product to be stored as a unique document without forcing it to follow a strict schema that would need to include all possible attributes.

- **Big Data and IoT Applications**. MongoDB is often used in Big Data and Internet of Things (IoT) environments, where large volumes of data are collected from various sources. The ability to store data in JSON/BSON format facilitates the ingestion of semi-structured or unstructured data coming from sensors and connected devices. Its horizontal scalability (sharding) allows efficient management of massive data growth.

- **User Profiles and Social Networks**. Applications that manage user profiles, preferences, and interactions also use MongoDB. A user profile can contain a lot of related information (messages, friend lists, purchase history) that can be grouped into a single document, improving query performance. Graph databases (such as Neo4j) are more suitable for relationship traversal, but MongoDB can be efficiently used to store and retrieve profile data flexibly.

- **Geospatial Data**. MongoDB includes robust support for geospatial queries and data. This feature allows it to compete in the niche of location-based applications, mapping services, geolocation applications, and games that require location-based data.
