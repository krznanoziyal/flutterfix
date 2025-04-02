import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/app_bar_widget.dart';
import '../models/user_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<String> _filterOptions = ['All', 'Today', 'Upcoming', 'Completed', 'Important'];
  String _selectedFilter = 'All';

  // Mock task data
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Update dashboard design',
      description: 'Improve UI/UX of analytics dashboard',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: Priority.high,
      isCompleted: false,
      assignee: User(id: '1', name: 'John Doe', email: 'john@example.com', avatarUrl: 'https://via.placeholder.com/150', role: ''),
      tags: ['Design', 'Dashboard'],
    ),
    // Task(
    //   id: '2',
    //   title: 'Fix navigation bug',
    //   description: 'Fix the sidebar navigation toggle issue',
    //   dueDate: DateTime.now(),
    //   priority: Priority.medium,
    //   isCompleted: false,
    //   assignee: User(id: '2', name: 'Jane Smith', email: 'jane@example.com', avatarUrl: 'https://via.placeholder.com/150'),
    //   tags: ['Bug', 'Navigation'],
    // ),
    // Task(
    //   id: '3',
    //   title: 'Create API documentation',
    //   description: 'Document all API endpoints for developers',
    //   dueDate: DateTime.now().add(const Duration(days: 3)),
    //   priority: Priority.medium,
    //   isCompleted: false,
    //   assignee: User(id: '1', name: 'John Doe', email: 'john@example.com', avatarUrl: 'https://via.placeholder.com/150'),
    //   tags: ['Documentation', 'API'],
    // ),
    // Task(
    //   id: '4',
    //   title: 'Unit testing for authentication module',
    //   description: 'Write unit tests for login and registration flows',
    //   dueDate: DateTime.now().add(const Duration(days: 2)),
    //   priority: Priority.high,
    //   isCompleted: false,
    //   assignee: User(id: '3', name: 'Alex Johnson', email: 'alex@example.com', avatarUrl: 'https://via.placeholder.com/150'),
    //   tags: ['Testing', 'Authentication'],
    // ),
    // Task(
    //   id: '5',
    //   title: 'Optimize database queries',
    //   description: 'Improve performance of slow queries',
    //   dueDate: DateTime.now().subtract(const Duration(days: 1)),
    //   priority: Priority.critical,
    //   isCompleted: true,
    //   assignee: User(id: '4', name: 'Sarah Williams', email: 'sarah@example.com', avatarUrl: 'https://via.placeholder.com/150'),
    //   tags: ['Database', 'Performance'],
    // ),
    // Task(
    //   id: '6',
    //   title: 'Weekly team meeting',
    //   description: 'Discuss project progress and roadblocks',
    //   dueDate: DateTime.now(),
    //   priority: Priority.low,
    //   isCompleted: false,
    //   assignee: User(id: '1', name: 'John Doe', email: 'john@example.com', avatarUrl: 'https://via.placeholder.com/150'),
    //   tags: ['Meeting', 'Team'],
    // ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Task> get _filteredTasks {
    List<Task> filtered = [];
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = _tasks.where((task) => 
        task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        task.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        task.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()))
      ).toList();
    } else {
      filtered = List.from(_tasks);
    }
    
    // Apply status filter
    switch (_selectedFilter) {
      case 'Today':
        final now = DateTime.now();
        filtered = filtered.where((task) => 
          task.dueDate.year == now.year && 
          task.dueDate.month == now.month && 
          task.dueDate.day == now.day
        ).toList();
        break;
      case 'Upcoming':
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        filtered = filtered.where((task) => 
          task.dueDate.isAfter(tomorrow)
        ).toList();
        break;
      case 'Completed':
        filtered = filtered.where((task) => task.isCompleted).toList();
        break;
      case 'Important':
        filtered = filtered.where((task) => 
          task.priority == Priority.high || task.priority == Priority.critical
        ).toList();
        break;
      default:
        // 'All' - no additional filtering needed
        break;
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isDarkMode = theme.brightness == Brightness.dark;
    User user = User(id: '1', name: 'John Doe', email: 'john@example.com', avatarUrl: 'https://via.placeholder.com/150', role: '');

    
    return Scaffold(
      appBar: CustomAppBar(title: 'Tasks', user: user, onMenuTap: (){} ,),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    suffixIcon: _searchQuery.isNotEmpty 
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: _selectedFilter,
                      underline: Container(),
                      items: _filterOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedFilter = newValue!;
                        });
                      },
                    ),
                    Row(
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.sort),
                          label: const Text('Sort'),
                          onPressed: () {
                            _showSortOptions();
                          },
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('New Task'),
                          onPressed: () {
                            _showAddTaskDialog();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredTasks.isEmpty 
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.task_alt,
                      size: 80,
                      color: theme.disabledColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No tasks found',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try changing your search or filter',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = _filteredTasks[index];
                  final isOverdue = !task.isCompleted && task.dueDate.isBefore(DateTime.now());
                  
                  Color priorityColor;
                  switch (task.priority) {
                    case Priority.low:
                      priorityColor = Colors.green;
                      break;
                    case Priority.medium:
                      priorityColor = Colors.blue;
                      break;
                    case Priority.high:
                      priorityColor = Colors.orange;
                      break;
                    case Priority.critical:
                      priorityColor = Colors.red;
                      break;
                  }
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Container(
                          height: 4,
                          color: priorityColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: task.isCompleted,
                                    activeColor: theme.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        task.isCompleted = value!;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task.title,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          task.description,
                                          style: TextStyle(
                                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert),
                                    onSelected: (value) {
                                      switch (value) {
                                        case 'edit':
                                          _showEditTaskDialog(task);
                                          break;
                                        case 'delete':
                                          _showDeleteTaskDialog(task);
                                          break;
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, size: 20),
                                            SizedBox(width: 8),
                                            Text('Edit'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete, size: 20),
                                            SizedBox(width: 8),
                                            Text('Delete'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Chip(
                                    avatar: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: priorityColor,
                                      child: Text(
                                        task.priority.toString().split('.').last[0].toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    label: Text(task.priority.toString().split('.').last),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  const SizedBox(width: 8),
                                  Chip(
                                    avatar: Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: isOverdue ? Colors.red : null,
                                    ),
                                    label: Text(
                                      DateFormat('MMM d').format(task.dueDate),
                                      style: TextStyle(
                                        color: isOverdue ? Colors.red : null,
                                        fontWeight: isOverdue ? FontWeight.bold : null,
                                      ),
                                    ),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  const Spacer(),
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: theme.primaryColor.withOpacity(0.2),
                                    child: Text(
                                      task.assignee.name.substring(0, 1),
                                      style: TextStyle(
                                        color: theme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (task.tags.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  children: task.tags.map((tag) {
                                    return Chip(
                                      label: Text(
                                        tag,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      backgroundColor: isDarkMode ? 
                                        Colors.grey[800] : Colors.grey[200],
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    );
                                  }).toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog();
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Sort by', style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Due Date'),
                onTap: () {
                  setState(() {
                    _tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('Priority'),
                onTap: () {
                  setState(() {
                    _tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.title),
                title: const Text('Title'),
                onTap: () {
                  setState(() {
                    _tasks.sort((a, b) => a.title.compareTo(b.title));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_circle),
                title: const Text('Completion Status'),
                onTap: () {
                  setState(() {
                    _tasks.sort((a, b) => a.isCompleted ? 1 : -1);
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddTaskDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    Priority selectedPriority = Priority.medium;
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Task'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Due Date'),
                      subtitle: Text(DateFormat('MMM d, y').format(selectedDate)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<Priority>(
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedPriority,
                      items: Priority.values.map((Priority priority) {
                        return DropdownMenuItem<Priority>(
                          value: priority,
                          child: Text(priority.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (Priority? value) {
                        setState(() {
                          selectedPriority = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('CANCEL'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      final newTask = Task(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.text,
                        description: descriptionController.text,
                        dueDate: selectedDate,
                        priority: selectedPriority,
                        isCompleted: false,
                        assignee: User(id: '1', name: 'John Doe', email: 'john@example.com', avatarUrl: 'https://via.placeholder.com/150', role: ''),
                        tags: [],
                    
                      );
                      setState(() {
                        _tasks.add(newTask);
                      });
                      
                      Navigator.pop(context);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Task added successfully'),
                          action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: () {
                              setState(() {
                                _tasks.remove(newTask);
                              });
                            },
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Title cannot be empty'),
                        ),
                      );
                    }
                  },
                  child: const Text('ADD'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditTaskDialog(Task task) {
    final TextEditingController titleController = TextEditingController(text: task.title);
    final TextEditingController descriptionController = TextEditingController(text: task.description);
    DateTime selectedDate = task.dueDate;
    Priority selectedPriority = task.priority;
    List<String> tags = List.from(task.tags);
    final TextEditingController tagController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Task'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Due Date'),
                      subtitle: Text(DateFormat('MMM d, y').format(selectedDate)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<Priority>(
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedPriority,
                      items: Priority.values.map((Priority priority) {
                        return DropdownMenuItem<Priority>(
                          value: priority,
                          child: Text(priority.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (Priority? value) {
                        setState(() {
                          selectedPriority = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tags'),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            ...tags.map((tag) => Chip(
                              label: Text(tag),
                              onDeleted: () {
                                setState(() {
                                  tags.remove(tag);
                                });
                              },
                            )),
                            InputChip(
                              label: SizedBox(
                                width: 80,
                                height: 24,
                                child: TextField(
                                  controller: tagController,
                                  decoration: const InputDecoration(
                                    hintText: 'Add tag',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onSubmitted: (value) {
                                    if (value.isNotEmpty && !tags.contains(value)) {
                                      setState(() {
                                        tags.add(value);
                                        tagController.clear();
                                      });
                                    }
                                  },
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('CANCEL'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      setState(() {
                        task.title = titleController.text;
                        task.description = descriptionController.text;
                        task.dueDate = selectedDate;
                        task.priority = selectedPriority;
                        task.tags = tags;
                      });
                      
                      Navigator.pop(context);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Task updated successfully'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Title cannot be empty'),
                        ),
                      );
                    }
                  },
                  child: const Text('UPDATE'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteTaskDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: Text('Are you sure you want to delete "${task.title}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _tasks.remove(task);
                });
                
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Task deleted'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        setState(() {
                          _tasks.add(task);
                        });
                      },
                    ),
                  ),
                );
              },
              child: const Text('DELETE', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

class Task {
  String id;
  String title;
  String description;
  DateTime dueDate;
  Priority priority;
  bool isCompleted;
  User assignee;
  List<String> tags;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
    required this.assignee,
    required this.tags,
  });
}

enum Priority {
  low,
  medium,
  high,
  critical,
}